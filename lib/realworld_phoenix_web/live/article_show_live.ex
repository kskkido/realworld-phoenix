defmodule RealworldPhoenixWeb.ArticleShowLive do
  use RealworldPhoenixWeb, :live_view
  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.Comment
  alias RealworldPhoenix.App.Profile
  alias RealworldPhoenixWeb.UserAuth

  on_mount {UserAuth, :mount_current_user}

  def mount(%{ "slug" => slug }, _session, %{ assigns: %{ current_user: nil } } = socket) do
    article = App.get_article_by!(slug: slug)
    socket = assign(socket, [ 
      article: article,
      user_profile: nil,
      ])
    {:ok, socket}
  end

  def mount(%{ "slug" => slug }, _session, %{ assigns: %{ current_user: user } } = socket) do
    article = App.get_article_by!(slug: slug)
    user_profile = App.get_profile_by_user!(user)
    comment_form = to_form(App.change_comment(%App.Comment{}), as: "comment")
    socket = assign(socket, [ 
      article: article,
      user_profile: user_profile,
      comment_form: comment_form,
      comment_form_valid: true
    ])
    {:ok, socket}
  end

  def handle_event("delete_article", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("delete_article", _params, %{ assigns: %{ article: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("delete_article", _params, %{ assigns: %{ article: article, user_profile: author } } = socket) do
    cond do
      author.id == article.author.id -> 
        case App.delete_article(article) do
          {:ok, _article} ->
            put_flash(socket, :info, "Deleted article successfully.")
            {:noreply, push_redirect(socket, to: "/") }
          {:error, _changeset} ->
            put_flash(socket, :info, "Unable to delete article.")
            {:noreply, socket}
        end
      true -> 
        {:noreply, socket}
    end
  end

  def handle_event("submit_article_comment", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("submit_article_comment", _params, %{ assigns: %{ article: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("submit_article_comment", %{"comment" => comment_params}, %{ assigns: %{ article: article, user_profile: author } } = socket) do
    cond do
      author.id == article.author.id -> 
        case App.create_article_comment(author, article, comment_params) do
          {:ok, _comment} ->
            put_flash(socket, :info, "Article comment created successfully.")
            socket = assign(socket, %{
              article: App.get_article_by!(id: article.id),
            })
            {:noreply, socket}
          {:error, changeset} ->
            put_flash(socket, :info, "Unable to create article comment.")
            comment_form = to_form(changeset, as: "comment")
            socket = assign(socket, %{ 
              comment_form: comment_form,
              comment_form_valid: changeset.valid?
            })
            {:noreply, socket}
        end
      true -> 
        {:noreply, socket}
    end
  end

  def handle_event("validate_article_comment", %{"comment" => comment_params}, socket) do
    changeset = App.change_comment(%Comment{}, comment_params) |> Map.put(:action, :validate)
    comment_form = to_form(changeset, as: "comment")
    socket = assign(socket, %{
      comment_form: comment_form,
      comment_form_valid: changeset.valid?
    })
    {:noreply, socket}
  end

  def handle_event("delete_article_comment", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("delete_article_comment", _params, %{ assigns: %{ article: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("delete_article_comment", %{ "comment_id" => comment_id }, %{ assigns: %{ article: article, user_profile: author } } = socket) do
    comment =
      article.comments
      |> Enum.find(&(&1.id == String.to_integer(comment_id)))
    cond do
      comment && author.id == comment.author.id -> 
        case App.delete_comment(comment) do
          {:ok, _comment} ->
            put_flash(socket, :info, "Deleted article successfully.")
            socket = assign(socket, %{
              article: App.get_article_by!(id: article.id),
            })
            {:noreply, socket}
          {:error, _changeset} ->
            put_flash(socket, :info, "Unable to delete article.")
            {:noreply, socket}
        end
      true -> 
        {:noreply, socket}
    end
  end

  def handle_event("toggle_follower", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_follower", _params, %{ assigns: %{ article: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_follower", _params, %{ assigns: %{ article: article, user_profile: follower } } = socket) do
    case App.toggle_follow_profile(article.author, follower) do
      {:ok, _profile_follower} ->
        put_flash(socket, :info, "Followed profile successfully.")
        socket = assign(socket, %{
          article: App.get_article_by!(id: article.id),
          user_profile: App.get_profile!(follower.id)
        })
        {:noreply, socket}
      {:error, _changeset} ->
        put_flash(socket, :info, "Unable to follow profile.")
        {:noreply, socket}
    end
  end

  def handle_event("toggle_favorite", _params, %{ assigns: %{ article: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_favorite", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_favorite", _paramas, %{ assigns: %{ article: article, user_profile: profile } } = socket) do
    case App.toggle_favorite_article(profile, article) do
      {:ok, article} ->
        put_flash(socket, :info, "Toggled article favorite successfully.")
        socket = assign(socket, [
          article: App.get_article_by!(id: article.id),
          user_profile: App.get_profile_by!(id: profile.id)
        ])
        {:noreply, socket}
      {:error, _changeset} ->
        put_flash(socket, :info, "Unable to toggle favorite article.")
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="article-page">
      <div class="banner">
        <div class="container">
          <h1>
            <%= @article.title %>
          </h1>
          <div class="article-meta">
            <.link href={~p"/profiles/#{@article.author.id}"}>
              <img src={@article.author.image} />
            </.link>
            <div class="info">
              <.link class="author" href={~p"/profiles/#{@article.author.id}"}>
                <%= @article.author.username %>
              </.link>
              <span class="date">
                <%= @article.inserted_at %>
              </span>
              <%= if @user_profile do %>
                <%= if @user_profile.id == @article.author.id do %>
                  <span>
                    <.link
                      class="btn btn-outline-secondary btn-sm"
                      href={~p"/editor/#{@article.id}"}
                    >
                      <i class="ion-edit">
                        Edit Article
                      </i>
                    </.link>
                    <.button
                      class="btn btn-outline-danger btn-sm"
                      phx-click="delete_article"
                    >
                      <i class="ion-trash-a">
                        Delete Article
                      </i>
                    </.button>
                  </span>
                <% else %>
                  <%= if App.Profile.following(@user_profile, @article.author) do %>
                    <.button
                      class="btn btn-sm action-btn ng-binding btn-outline-secondary"
                      phx-click="toggle_follower"
                    >
                      <i class="ion-minus-round">
                      </i>
                      <span>
                        Unfollow <%= @article.author.username %>
                      </span>
                    </.button>
                  <% else %>
                    <.button
                      class="btn btn-sm action-btn ng-binding btn-outline-secondary"
                      phx-click="toggle_follower"
                    >
                      <i class="ion-plus-round">
                      </i>
                      <span>
                        Follow <%= @article.author.username %>
                      </span>
                    </.button>
                  <% end %>
                  <.button
                    class={"
                      btn
                      btn-sm
                      #{ if @user_profile && Profile.favorited(@user_profile, @article) do "btn-primary" else "btn-outline-primary" end }
                    "}
                    phx-click="toggle_favorite"
                  >
                    <i class="ion-heart mr-1" >
                      <%= length(@article.article_favorites) %>
                    </i>
                  </.button>
                <% end %>
              <% end %>
            </div>
          </div>
        </div>
      </div>
      <div class="container page">
        <div class="row article-content">
          <div class="col-xs-12">
            <div>
              <%= @article.body %>
            </div>
            <ul>
            </ul>
          </div>
        </div>
        <hr/>
        <div class="row">
          <div class="col-xs-12 col-md-8 offset-md-2">
            <%= if @user_profile do %>
              <.simple_form
                class="card comment-form"
                for={@comment_form}
                phx-submit="submit_article_comment"
                phx-change="validate_article_comment"
              >
                <.error :if={!@comment_form_valid}>
                  Oops, something went wrong! Please check the errors below.
                </.error>
                <.input type="textarea" field={@comment_form[:body]} label="Body" />
                <:actions>
                  <.button>Save Comment</.button>
                </:actions>
              </.simple_form>
            <% end %>
            <div
              class="card"
              :for={comment <- @article.comments}
            >
              <div class="card-block">
                <p class="card-text">
                  <%= comment.body %>
                </p>
              </div>
              <div class="card-footer">
                <.link class="comment-author-image" href={~p"/profiles/#{comment.author.id}"}>
                  <img class="comment-author-img" src={comment.author.image} />
                </.link>
                <.link class="comment-author" href={~p"/profiles/#{comment.author.id}"}>
                  <%= comment.author.username %>
                </.link>
                <span class="date-posted">
                  <%= comment.inserted_at %>
                </span>
                <%= if @user_profile && @user_profile.id == comment.author.id do %>
                  <span class="mod-options">
                    <i class="ion-trash-a" phx-click="delete_article_comment" phx-value-comment_id={comment.id}>
                    </i>
                  </span>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

end
