defmodule OneMax do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.{Chromosome, Genotype}

  @size 42

  @impl true
  def fitness_function(chromosome) do
    Enum.sum(chromosome.genes)
  end

  @impl true
  def genotype do
    %Chromosome{genes: Genotype.binary(@size), size: @size}
  end

  @impl true
  def terminate?([best | _], generation) do
    best.fitness == @size or generation == 100
  end
end

OneMax
|> Genetic.run()
|> IO.inspect()
