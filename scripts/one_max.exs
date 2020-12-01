defmodule OneMax do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @size 42

  @impl true
  def fitness_function(chromosome) do
    Enum.sum(chromosome.genes)
  end

  @impl true
  def genotype do
    %Chromosome{genes: for(_ <- 1..@size, do: Enum.random(0..1)), size: @size}
  end

  @impl true
  def terminate?(_population, generation) do
    generation == 100
  end
end

OneMax
|> Genetic.run()
|> IO.inspect()
