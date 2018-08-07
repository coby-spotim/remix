# RemixedRemix

An updated version of the [original remix project](https://github.com/AgilionApps/remix).

Since this project has not responded to any issues or pull requests in two years,
I decided to fork it, fix the bugs and warnings that I spotted, and [republish it to Hex](https://hex.pm/packages/remixed_remix).

Most of the usage and configurations are the same, thanks to the great work by the Agilion team.

I only went through and fixed the issues that were causing warnings and compilation problems when
I ran it on my machine, so if I missed anything, pull requests are welcome. I'll gladly review and accept them.

If you want to submit an issue, I will try and get to it as soon as I can.

## Installation

Add remixed_remix to deps:

```elixir
defp deps do
  [{:remixed_remix, ">= 0.0.0", only: :dev}]
end
```

Add add `:remixed_remix` as a development only OTP app.

```elixir

def application do
  [applications: applications(Mix.env)]
end

defp applications(:dev), do: applications(:all) ++ [:remixed_remix]
defp applications(_all), do: [:logger] # or any other applications that you have

```

with escript compilation (in config.exs) and
silent mode (won't output to iex each time it compiles):
```elixir
config :remixed_remix,
  escript: true,
  silent: true
```
If these vars are not set, it will default to verbose (silent: false) and no escript compilation (escript: false).

## Usage

Save or create a new file in the lib directory. Thats it!

## License

The Remixed_Remix source code is released under the MIT License. Check LICENSE file for more information.
