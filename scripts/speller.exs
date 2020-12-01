defmodule Speller do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @size 34
  @target "supercalifragilisticexpialidocious"

  @impl true
  def genotype do
    %Chromosome{
      genes:
        fn -> Enum.random(?a..?z) end
        |> Stream.repeatedly()
        |> Enum.take(@size),
      size: @size
    }
  end

  @impl true
  def fitness_function(chromosome) do
    String.jaro_distance(@target, List.to_string(chromosome.genes))
  end

  @impl true
  def terminate?(population, generation) do
    # hd(population).fitness == 1.0
    # Enum.max_by(population, &fitness_function/1).fitness == 1.0
    generation == 1000
  end
end

Speller
|> Genetic.run()
|> IO.inspect()
