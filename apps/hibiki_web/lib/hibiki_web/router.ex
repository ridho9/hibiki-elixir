defmodule HibikiWeb.Router do
  use Raxx.Router

  section([{Raxx.Logger, level: :info}], [
    {%{path: []}, HibikiWeb.Page.Hello},
    {%{path: ["hibiki"]}, HibikiWeb.Server},
    {_, HibikiWeb.Page.NotFound}
  ])
end
