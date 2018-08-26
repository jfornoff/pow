defmodule Pow.Phoenix.MailerTemplate do
  @moduledoc false
  use Pow.Phoenix.Mailer.Template

  template :mail_test,
  "Test subject",
  """
  <%= @value %> text
  """,
  """
  <%= content_tag(:h3, "\#{@value} HTML") %>
  """
end

defmodule Pow.Phoenix.MailerView do
  @moduledoc false
  use Pow.Phoenix.Mailer.View
end

defmodule Pow.Phoenix.Mailer.MailTest do
  use ExUnit.Case
  doctest Pow.Phoenix.Mailer.Mail

  alias Pow.Phoenix.Mailer.Mail
  alias Pow.Phoenix.MailerView

  test "new/4" do
    conn = %{private: %{pow_config: []}}
    assert mail = Mail.new(conn, :user, {MailerView, :mail_test}, value: "test")

    assert mail.user == :user
    assert mail.subject == "Test subject"
    assert mail.html =~ "<h3>test HTML</h3>"
    assert mail.text =~ "test text\n"
    assert mail.assigns[:value] == "test"
  end

  test "new/4 with :web_module" do
    conn = %{private: %{pow_config: [web_mailer_module: Pow.Test.Phoenix]}}
    assert mail = Mail.new(conn, :user, {MailerView, :mail_test}, value: "test")

    assert mail.user == :user
    assert mail.subject == ":web_mailer_module subject"
    assert mail.html == "<p>:web_mailer_module html mail</p>"
    assert mail.text == ":web_mailer_module text mail"
  end
end
