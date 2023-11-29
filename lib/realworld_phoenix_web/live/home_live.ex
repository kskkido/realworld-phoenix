defmodule RealworldPhoenixWeb.HomeLive do
  use RealworldPhoenixWeb, :live_view
  require Logger
  alias RealworldPhoenix.App
  alias RealworldPhoenix.App.Profile

  on_mount {RealworldPhoenixWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, %{ assigns: %{ current_user: nil }} = socket) do
    articles = App.list_articles_feed()
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "global",
      user_profile: nil,
    }))
    {:ok, socket}
  end

  def mount(_params, _session, %{ assigns: %{ current_user: user }} = socket) do
    profile = App.get_profile_by!(user_id: user.id)
    articles = App.list_articles_feed(follower_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "personal",
      user_profile: profile
    }))
    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    articles = App.list_articles_feed()
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "global"
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

  def handle_event("get_personal_articles", _params, %{ assigns: %{ user_profile: nil }} = socket) do
    {:noreply, socket}
  end
  def handle_event("get_personal_articles", _params, %{ assigns: %{ user_profile: profile }} = socket) do
    articles = App.list_articles_feed(follower_id: profile.id)
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "personal"
    }))
    {:noreply, socket}
  end

  def handle_event("get_global_articles", _params, socket) do
    articles = App.list_articles_feed()
    socket = assign(socket, Map.merge(normalize_articles(articles), %{ 
      current_tab: "global"
    }))
    {:noreply, socket}
  end

  def handle_event("toggle_favorite", _params, %{ assigns: %{ user_profile: nil }} = socket) do
    {:noreply, socket}
  end
  def handle_event("toggle_favorite", %{"id" => id}, %{ assigns: %{ user_profile: profile }} = socket) do
    article_id = String.to_existing_atom(id)
    article = socket.assigns.article_by_id[article_id]
    case App.toggle_favorite_article(profile, article) do
      {:ok, article} ->
        put_flash(socket, :info, "Toggled article favorite successfully.")
        socket = assign(socket, [
          user_profile: App.get_profile_by!(id: profile.id),
          article_by_id: Map.put(socket.assigns.article_by_id, article_id, article),
        ])
        {:noreply, socket}
      {:error, _changeset} ->
        put_flash(socket, :info, "Unable to toggle favorite article.")
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="home-page">
      <div class="banner">
        <div class="container">
          <h1 class="logo-font">
            conduit
          </h1>
          <p class="logo-font">
            A place to share your knowledge.
          </p>
        </div>
      </div>
      <div class="container page">
        <div class="row">
          <div class="col-md-9">
            <div class="feed-toggle">
              <ul class="nav nav-pills outline-active">
                <%= if @user_profile do %>
                  <li class="nav-item">
                    <.button
                      class={"
                        nav-link
                        #{if @current_tab == "personal" do 'active' end}
                      "}
                      phx-click="get_personal_articles"
                    >
                      Your Feed
                    </.button>
                  </li>
                <% end %>
                <li class="nav-item">
                  <.button
                    class={"
                      nav-link
                      #{if @current_tab == "global" do 'active' end}
                    "}
                    phx-click="get_global_articles"
                  >
                    Global Feed
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
