defmodule Hibiki.Registry do
  def subcommands, do: default_commands()

  def default_commands do
    app = Application.get_application(__MODULE__)
    {:ok, modules} = :application.get_key(app, :modules)

    command_modules =
      modules
      |> Enum.filter(&Teitoku.Command.command?/1)

    children_modules =
      Enum.reduce(command_modules, [], fn x, acc ->
        acc ++ x.subcommands()
      end)

    command_modules
    |> Enum.filter(fn module -> module not in children_modules end)
  end
end
