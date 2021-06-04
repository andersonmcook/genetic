defmodule Genetic do
  @moduledoc false

  require Integer

  alias Genetic.{Crossover, Mutation, Population, Selection}

  @defaults %{
    crossover_type: &Crossover.single_point/2,
    mutation_rate: 0.05,
    mutation_type: &Mutation.scramble/1,
    population_size: 100,
    selection_rate: 0.8,
    selection_type: &Selection.elite/2
  }

  def run(problem, opts \\ []) do
    opts = Map.new(@defaults, fn {key, value} -> {key, Keyword.get(opts, key, value)} end)

    opts.population_size
    |> Population.populate(&problem.genotype/0)
    |> evolve(problem, 0, opts)
  end

  defp evaluate(population, fitness_function) do
    population
    |> Enum.map(&%{&1 | age: &1.age + 1, fitness: fitness_function.(&1)})
    |> Enum.sort_by(& &1.fitness, :desc)
  end

  defp select(population, selection_rate, selection_type) do
    # Number of parents
    n = round(length(population) * selection_rate)

    # Ensure even number of parents
    n = if Integer.is_even(n), do: n, else: n + 1

    parents = selection_type.(population, n)

    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))
      |> MapSet.to_list()

    parents =
      parents
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)

    {parents, leftover}
  end

  defp crossover(population, crossover_type) do
    Enum.reduce(population, [], fn {p1, p2}, acc ->
      {c1, c2} = crossover_type.(p1, p2)
      [c1, c2 | acc]
    end)
  end

  defp mutate(chromosome, opts) do
    if :rand.uniform() < opts.mutation_rate do
      Map.update!(chromosome, :genes, opts.mutation_type)
    else
      chromosome
    end
  end

  defp mutation(population, opts) do
    Enum.map(population, &mutate(&1, opts))
  end

  defp evolve(population, problem, generation, opts) do
    [best | _] = population = evaluate(population, &problem.fitness_function/1)

    IO.puts("Current Best: #{best.fitness}")

    if problem.terminate?(population, generation) do
      best
    else
      {parents, leftover} = select(population, opts.selection_rate, opts.selection_type)

      children = crossover(parents, opts.crossover_type)

      (children ++ leftover)
      |> mutation(opts)
      |> evolve(problem, generation + 1, opts)
    end
  end
end
