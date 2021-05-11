defmodule OneMaxInteractive do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.{Chromosome, Genotype}

  @size 42

  @impl true
  def genotype do
    %Chromosome{genes: Genotype.binary(@size), size: @size}
  end

  @impl true
  def fitness_function(chromosome) do
    IO.inspect(chromosome)

    "Rate from 1 to 10\n"
    |> IO.gets()
    |> String.trim()
    |> String.to_integer()
  end

  @impl true
  def terminate?([best | _], generation) do
    best.fitness == 10 or generation == 10
  end
end

OneMaxInteractive
|> Genetic.run()
|> IO.inspect()
