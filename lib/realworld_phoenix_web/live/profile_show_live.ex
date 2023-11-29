defmodule RealworldPhoenixWeb.ProfileShowLive do
  use RealworldPhoenixWeb, :live_view
  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.Profile
  alias RealworldPhoenixWeb.UserAuth

  on_mount {UserAuth, :mount_current_user}

  def mount(%{ "id" => id }, _session, %{ assigns: %{ current_user: nil } } = socket) do
    profile = App.get_profile!(id)
    articles = App.list_articles_feed(author_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      profile: profile,
      user_profile: nil,
      current_tab: "authored"
    }))
    {:ok, socket}
  end

  def mount(%{ "id" => id }, _session, %{ assigns: %{ current_user: user } } = socket) do
    profile = App.get_profile!(id)
    articles = App.list_articles_feed(author_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      profile: profile,
      user_profile: App.get_profile_by_user!(user),
      current_tab: "authored"
    }))
    {:ok, socket}
  end

  def normalize_articles(articles) do
    articles_with_id = 
      articles
      |> Enum.map(&({String.to_atom("#{&1.id}"), &1}))
    %{
      article_ids: articles_with_id |> Enum.map(&(&1 |> elem(0))),
      article_by_id: articles_with_id |> Enum.into(%{})
    }
  end

  def handle_event("get_authored_articles", _params, %{ assigns: %{ profile: profile }} = socket) do
    articles = App.list_articles_feed(author_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "authored"
    }))
    {:noreply, socket}
  end

  def handle_event("get_favorited_articles", _params, %{ assigns: %{ profile: profile }} = socket) do
    articles = App.list_articles_feed(favorited_by_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "favorited"
    }))
    {:noreply, socket}
  end

  def handle_event("toggle_follower", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_follower", _params, %{ assigns: %{ profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_follower", _params, %{ assigns: %{ profile: following, user_profile: follower } } = socket) do
    case App.toggle_follow_profile(following, follower) do
      {:ok, _profile_follower} ->
        put_flash(socket, :info, "Followed profile successfully.")
        socket = assign(socket, %{
          profile: App.get_profile!(following.id),
          user_profile: App.get_profile!(follower.id)
        })
        {:noreply, socket}
      {:error, _changeset} ->
        put_flash(socket, :info, "Unable to follow profile.")
        {:noreply, socket}
    end
  end

  def handle_event("toggle_favorite", _params, %{ assigns: %{ user_profile: nil } } = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_favorite", %{"id" => id}, %{ assigns: %{ user_profile: profile } } = socket) do
    article_id = String.to_existing_atom(id)
    article = socket.assigns.article_by_id[article_id]
    case App.toggle_favorite_article(profile, article) do
      {:ok, article} ->
        put_flash(socket, :info, "Toggled article favorite successfully.")
        socket = assign(socket, [
          user_profile: App.get_profile_by!(id: profile.id),
          article_by_id: Map.put(socket.assigns.article_by_id, article_id, article)
        ])
        {:noreply, socket}
      {:error, _changeset} ->
        put_flash(socket, :info, "Unable to toggle favorite article.")
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="profile-page">
      <div class="user-info">
        <div class="container page">
          <div class="row">
            <div class="col-xs-12 col-md-10 offset-md-1">
              <img class="user-image mx-auto" src={@profile.image} />
              <h4>
                <%= @profile.username %>
              </h4>
              <p>
                <%= @profile.bio %>
              </p>
              <%= if @user_profile do %>
                <%= if @user_profile.id == @profile.id do %>
                  <.link
                    class="btn btn-sm action-btn ng-binding btn-outline-secondary"
                    href={~p"/settings"}
                  >
                    <i class="ion-gear-a">
                    </i>
                    <span>
                      Edit <%= @profile.username %>
                    </span>
                  </.link>
                <% else %>
                  <%= if App.Profile.following(@user_profile, @profile) do %>
                    <.button
                      class="btn btn-sm action-btn ng-binding btn-outline-secondary"
                      phx-click="toggle_follower"
                    >
                      <i class="ion-minus-round">
                      </i>
                      <span>
                        Unfollow <%= @profile.username %>
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
                        Follow <%= @profile.username %>
                      </span>
                    </.button>
                  <% end %>
                <% end %>
              <% end %>
            </div>
          </div>
        </div>
      </div>
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-md-10 offset-md-1">
            <div class="feed-toggle">
              <ul class="nav nav-pills outline-active">
                <li class="nav-item">
                  <.button
                    class={"
                      nav-link
                      #{if @current_tab == "authored" do 'active' end}
                    "}
                    phx-click="get_authored_articles"
                  >
                    My Articles
                  </.button>
                </li>
                <li class="nav-item">
                  <.button
                    class={"
                      nav-link
                      #{if @current_tab == "favorited" do 'active' end}
                    "}
                    phx-click="get_favorited_articles"
                  >
                    Favorited Articles
                  </.button>
                </li>
              </ul>
            </div>
            <div>
              <div
                :for={{id, article} <- Enum.map(@article_ids, &({&1, @article_by_id[&1]}))}
                class="article-preview"
              >
                <div class="article-meta">
                  <.link href={~p"/profiles/#{article.author}"}>
                    <img src={article.author.image} />
                  </.link>
                  <div class="info">
                    <.link class="author" href={~p"/profiles/#{article.author}"}>
                      <%= article.author.username %>
                    </.link>
                    <span class="date">
                      <%= article.inserted_at %>
                    </span>
                  </div>
                  <.button
                    class={"
                      btn
                      btn-sm
                      #{ if @user_profile && Profile.favorited(@user_profile, article) do "btn-primary" else "btn-outline-primary" end }
                    "}
                    phx-click="toggle_favorite"
                    phx-value-id={id}
                  >
                    <i class="ion-heart mr-1" >
                      <%= length(article.article_favorites) %>
                    </i>
                  </.button>
                </div>
                <div class="preview-link">
                  <.link href={~p"/articles/#{article.slug}"}>
                    <h1>
                      <%= article.title %>
                    </h1>
                    <p>
                      <%= article.description %>
                    </p>
                    <span>
                      Read more...
                    </span>
                  </.link>
                  <ul class="tag-list">
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

end
