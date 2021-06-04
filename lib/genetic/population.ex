defmodule Genetic.Population do
  @moduledoc false

  @doc false
  def populate(size, genotype) do
    for _ <- 1..size, do: genotype.()
  end
end
