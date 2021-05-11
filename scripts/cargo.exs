defmodule Cargo do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @size 10
  @profits [6, 5, 8, 9, 6, 7, 3, 1, 2, 6]
  @weights [10, 6, 8, 7, 10, 9, 7, 11, 6, 8]
  @weight_limit 40
  @max_profit 53

  @impl true
  def genotype do
    %Chromosome{genes: Enum.map(1..@size, fn _ -> Enum.random(0..1) end), size: @size}
  end

  @impl true
  def fitness_function(chromosome) do
    potential_profits =
      @profits
      |> Enum.zip(chromosome.genes)
      |> Enum.reduce(0, fn {p, g}, acc -> p * g + acc end)

    total_weight =
      @weights
      |> Enum.zip(chromosome.genes)
      |> Enum.reduce(0, fn {w, g}, acc -> w * g + acc end)

    if total_weight > @weight_limit do
      0
    else
      potential_profits
    end
  end

  @impl true
  def terminate?(population, generation) do
    Enum.max_by(population, &fitness_function/1).fitness == @max_profit or
      generation == 5000
  end
end

solution =
  Cargo
  |> Genetic.run(population_size: 50)
  |> IO.inspect()

weight =
  solution.genes
  |> Enum.zip([10, 6, 8, 7, 10, 9, 7, 11, 6, 8])
  |> Enum.reduce(0, fn {g, w}, acc -> g * w + acc end)

IO.puts("Weight is: #{weight}")
