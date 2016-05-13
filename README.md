# ExCLI

[![Build Status](https://travis-ci.org/tuvistavie/ex_cli.svg?branch=master)](https://travis-ci.org/tuvistavie/ex_cli)
[![Coverage Status](https://coveralls.io/repos/github/tuvistavie/ex_cli/badge.svg?branch=master)](https://coveralls.io/github/tuvistavie/ex_cli?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cli.svg?maxAge=2592000)](https://hex.pm/packages/ex_cli)

Elixir library to build CLI applications.

## Installation

Add `ex_cli` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_cli, "~> 0.1.0"}]
end
```

## Usage

The basic usage is to use `ExCLI.DSL` to define your CLI, and `ExCLI.run` to run it.
Here is a sample application:


```elixir
defmodule MyApp.SampleCLI do
  use ExCLI.DSL

  name "mycli"
  description "My CLI"
  long_description ~s"""
  This is my long description
  """

  option :verbose, count: true, aliases: [:v]

  command :hello do
    description "Greets the user"
    long_description """
    Gives a nice a warm greeting to whoever would listen
    """

    argument :name
    option :from, help: "the sender of hello"

    run context do
      if context.verbose > 0 do
        IO.puts("Running hello command")
      end
      if from = context[:from] do
        IO.write("#{from} says: ")
      end
      IO.puts("Hello #{context.name}!")
    end
  end
end

ExCLI.run!(MyApp.SampleCLI)
```

Which can be used in the following way.

```
sample_cli hello -vv world --from me
```

The application usage will be shown if the parsing fails. The above example would show:

```
usage: mycli [--verbose] <command> [<args>]

Commands
   hello   Greets the user
```

## `escript` and `mix` integration

You can very easily generate a mix task or an escript using `ExCLI`

### `escript`

Pass `escript: true` to the `use ExCLI.DSL` and set the module as `escript` `:main_module`:

```elixir
# lib/my_escript_cli.ex
defmodule MyEscriptCLI do
  use ExCLI, escript: true
end

# mix.exs
defmodule MyApp.Mixfile do
  def project do
    [app: :my_app,
     escript: [main_module: MyEscriptCLI]]
  end
end
```

Here is a small screencast of what it looks like:

![screencast][2]

### `mix` integration

Pass `mix_task: TASK_NAME` to the `use ExCLI.DSL`.

```elixir
# lib/my_cli_task.ex
defmodule MyCLITask do
  use ExCLI, mix_task: :great_task
end
```

You can then run

```
mix great_task
```

and get nicely formatted help with

```
mix help great_task
```


## Documentation

Check out the [documentation][1] for more information.

## Roadmap

  * [x] Command parser

    The command parser is now working and should be enough for a good number of tasks.

  * [x] Integration with `escript` and `mix`

    `ExCLI.DSL` can generate a module compatible with `escript.build` as well as a `mix` task.

  * [x] Usage generation

    A nicely formatted usage is generated from the DSL.

  * [ ] Help command

    Then the goal will be to add a `help` command which can be used as `app help command` to show help about `command`.

  * [ ] Command parser improvements

    When the usage and help parts are done, there are a few improvements that will be nice to have in the command parser:

      * the ability to set a default command
      * the ability to easily delegate a command to another module
      * fuzzy handling of command (i.e. `npm insta` will run `npm install`)

  * [ ] Man page generation

    When all this is done, the last part will to generate documentation in man page and markdown formats, which will probably be done as a mix task.

## Contributing

Contributions are very welcome, feel free to open an issue or a PR.

I am also looking for a better name, ideas are welcome!

[1]: https://hexdocs.pm/ex_cli/api-reference.html
[2]: https://cloud.githubusercontent.com/assets/1436271/15253363/e488b5ce-196c-11e6-97e0-e596d26ec0f1.gif
