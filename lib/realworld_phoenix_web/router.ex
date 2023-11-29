defmodule RealworldPhoenixWeb.Router do
  use RealworldPhoenixWeb, :router

  import RealworldPhoenixWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RealworldPhoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RealworldPhoenixWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/articles/:slug", ArticleShowLive
    live "/profiles/:id", ProfileShowLive
    delete "/logout", UserSessionController, :delete
    resources "/articles", ArticleController, except: [:show]
    resources "/profiles", ProfileController, except: [:show]
    live_session :current_user,
      on_mount: [{RealworldPhoenixWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/", RealworldPhoenixWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{RealworldPhoenixWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/register", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/", RealworldPhoenixWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/editor", ArticleController, :new
    get "/editor/:id", ArticleController, :edit
    live_session :require_authenticated_user,
      on_mount: [{RealworldPhoenixWeb.UserAuth, :ensure_authenticated}] do
      live "/settings", ProfileSettingsLive
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RealworldPhoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:realworld_phoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RealworldPhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
