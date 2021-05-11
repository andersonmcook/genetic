defmodule Genetic.Genotype do
  @moduledoc false

  @doc false
  def binary(size) do
    for _ <- 1..size, do: Enum.random(0..1)
  end
end
