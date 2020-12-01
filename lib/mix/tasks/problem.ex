defmodule Mix.Tasks.Problem do
  @moduledoc false

  use Mix.Task

  @impl true
  def run([module]) do
    module_name = Macro.camelize(module)
    path = "scripts/#{module}.exs"

    text = """
    defmodule #{module_name} do
      @moduledoc false

      @behaviour Genetic.Problem

      alias Genetic.Chromosome

      @impl true
      def genotype do
        # Replace
        %Chromosome{}
      end

      @impl true
      def fitness_function(chromosome) do
        # Replace
        0
      end

      @impl true
      def terminate?(population, generation) do
        # Replace
        true
      end
    end

    #{module_name}
    |> Genetic.run()
    |> IO.inspect()
    """

    File.write!(path, text)
    IO.puts("#{path} created")
  end
end
