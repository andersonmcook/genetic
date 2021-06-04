defmodule Schedule do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.{Chromosome, Genotype, Problem}

  @size 10

  @credit_hours [3.0, 3.0, 3.0, 4.5, 3.0, 3.0, 3.0, 3.0, 4.5, 1.5]
  @difficulties [8.0, 9.0, 4.0, 3.0, 5.0, 2.0, 4.0, 2.0, 6.0, 1.0]
  @interests [8.0, 8.0, 5.0, 9.0, 7.0, 2.0, 8.0, 2.0, 7.0, 10.0]
  @usefulness [8.0, 9.0, 6.0, 2.0, 8.0, 9.0, 1.0, 2.0, 5.0, 1.0]

  @impl Problem
  def genotype do
    %Chromosome{genes: Genotype.binary(@size), size: @size}
  end

  @impl Problem
  def fitness_function(chromosome) do
    schedule = chromosome.genes

    credit =
      schedule
      |> Enum.zip(@credit_hours)
      |> Enum.reduce(0, fn {class, credits}, sum ->
        class * credits + sum
      end)

    if credit > 18.0 do
      -99999
    else
      [schedule, @difficulties, @usefulness, @interests]
      |> Enum.zip()
      |> Enum.reduce(0, fn {class, difficulty, usefulness, interest}, sum ->
        class * (0.3 * usefulness + 0.3 * interest - 0.3 * difficulty) + sum
      end)
    end
  end

  @impl Problem
  def terminate?(_population, generation) do
    generation == 1000
  end
end

classes = [
  "Algorithms",
  "Artificial Intelligence",
  "Calculus",
  "Chemistry",
  "Data Structures",
  "Discrete Math",
  "History",
  "Literature",
  "Physics",
  "Volleyball"
]

selected_classes = fn chromosome ->
  chromosome
  |> Map.fetch!(:genes)
  |> Enum.zip(classes)
  |> Enum.reduce([], fn {selected, class}, acc ->
    if selected == 1 do
      [class | acc]
    else
      acc
    end
  end)
end

Schedule
|> Genetic.run()
|> selected_classes.()
|> IO.inspect(label: "selected_classes")
