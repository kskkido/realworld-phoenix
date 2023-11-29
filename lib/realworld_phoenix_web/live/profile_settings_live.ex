defmodule RealworldPhoenixWeb.ProfileSettingsLive do
  use RealworldPhoenixWeb, :live_view
  alias RealworldPhoenix.App
  alias RealworldPhoenix.Accounts

  on_mount {RealworldPhoenixWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, %{ assigns: %{ current_user: user }} = socket) do
    profile = App.get_profile_by!(user_id: user.id)
    settings_form = to_form(Accounts.change_user_settings(user), as: "settings")
    socket = assign(socket, %{ 
      profile: profile,
      settings_form: settings_form
    })
    {:ok, socket}
  end

  def handle_event("update_settings", %{"settings" => settings_params}, %{ assigns: %{ current_user: user } } = socket) do
    case Accounts.update_user_settings(user, settings_params) do
      {:ok, user} ->
        profile = App.get_profile_by!(user_id: user.id)
        settings_form = to_form(Accounts.change_user_settings(user), as: "settings")
        socket = assign(socket, %{ 
          profile: profile,
          settings_form: settings_form
        })
        {:noreply, socket}
      {:error, changeset} -> 
        settings_form = to_form(changeset, as: "settings")
        socket = assign(socket, %{ 
          settings_form: settings_form
        })
        {:noreply, socket}
    end
  end

  def handle_event("validate_settings", %{"settings" => settings_params}, %{ assigns: %{ current_user: user } } = socket) do
    settings_form =
      user
      |> Accounts.change_user_settings(settings_params)
      |> Map.put(:action, :validate)
      |> to_form(as: "settings")
    socket = assign(socket, %{ 
      settings_form: settings_form
    })
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="settings-page">
        <div class="container page">
          <div class="row">
            <div class="col-md-6 offset-md-3 col-xs-12">
              <h1 class="text-xs-center">
                Your Settings
              </h1>
              <.form
                :let={settings}
                for={@settings_form}
                phx-submit="update_settings"
                phx-change="validate_settings"
              >
                <fieldset>
                  <.inputs_for :let={profile} field={settings[:profile]}>
                    <fieldset class="form-group">
                      <.input class="form-control" field={profile[:image]} type="text" />
                    </fieldset>
                    <fieldset class="form-group">
                      <.input class="form-control form-control-lg" field={profile[:username]} type="text" />
                    </fieldset>
                    <fieldset class="form-group">
                      <.input class="form-control form-control-lg" field={profile[:bio]} type="textarea" />
                    </fieldset>
                  </.inputs_for>
                  <fieldset class="form-group">
                    <.input class="form-control form-control-lg" field={settings[:email]} type="email" />
                  </fieldset>
                  <fieldset class="form-group">
                    <.input class="form-control form-control-lg" field={settings[:password]} type="password" />
                  </fieldset>
                  <.button class="btn btn-lg pull-xs-right btn-primary">
                    Update Settings
                  </.button>
                </fieldset>
              </.form>
              <hr />
              <.link
                href={~p"/logout"}
                method="delete"
                class="btn btn-outline-danger"
              >
                Or click here to logout
              </.link>
            </div>
          </div>
        </div>
      </div>
    """
  end
end

