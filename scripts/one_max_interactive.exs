defmodule OneMaxInteractive do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @impl true
  def genotype do
    %Chromosome{genes: for(_ <- 1..@size, do: Enum.random(0..1)), size: @size}
  end

  @impl true
  def fitness_function(chromosome) do
    IO.inspect(chromosome)

    "Rate from 1 to 10"
    |> IO.get()
    |> String.to_integer()
  end

  @impl true
  def terminate?(_population, generation) do
    generation == 10
  end
end

OneMaxInteractive
|> Genetic.run()
|> IO.inspect()
