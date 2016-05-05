defmodule ExCLI.App do
  @moduledoc false

  defstruct [:name, :description, :long_description, options: [], commands: []]

  @type t ::  %__MODULE__{
    name: String.t | atom,
    description: String.t,
    long_description: String.t,
    options: [Keyword.t],
    commands: [ExCLI.Command.t]
  }

  @doc false
  def default_name(mod) do
    mod
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> Macro.underscore
  end
end
