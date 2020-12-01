defmodule Portfolio do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @size 10
  @target_fitness 180

  @impl true
  def genotype do
    %Chromosome{
      genes:
        Enum.map(1..@size, fn _ ->
          # {ROI, Risk}
          {:rand.uniform(@size), :rand.uniform(@size)}
        end),
      size: @size
    }
  end

  @impl true
  def fitness_function(chromosome) do
    # ROI is twice as important as risk
    Enum.reduce(chromosome.genes, 0, fn {roi, risk}, acc -> acc + (2 * roi - risk) end)
  end

  @impl true
  def terminate?(population, _generation) do
    Enum.max_by(population, &fitness_function/1).fitness > @target_fitness
  end
end

Portfolio
|> Genetic.run()
|> IO.inspect()
