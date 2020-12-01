defmodule Genetic.Chromosome do
  @moduledoc false

  @type t :: %__MODULE__{
          age: integer,
          fitness: number,
          genes: Enumerable.t(),
          size: integer
        }

  @enforce_keys [:genes]
  defstruct age: 0,
            fitness: 0,
            genes: nil,
            size: 0
end
