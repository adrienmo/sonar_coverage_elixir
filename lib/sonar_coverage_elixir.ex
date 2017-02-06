defmodule SonarCoverageElixir do
  def start(compile_path, _) do
    Mix.shell.info "Cover compiling modules ... "
    _ = :cover.start

    case :cover.compile_beam_directory(compile_path |> to_char_list) do
      results when is_list(results) ->
        :ok
      {:error, _} ->
        Mix.raise "Failed to cover compile directory: " <> compile_path
    end

    fn() ->
      generate_generic_coverage
    end
  end

  def generate_generic_coverage do
    Mix.shell.info "\nGenerating generic_coverage.xml... "

    root = {:coverage, [
        version: "1",
      ], Enum.map(:cover.modules, fn mod ->
        {:file,
          [
            path: Path.relative_to_cwd(mod.module_info(:compile)[:source]),
          ],
        lines(mod)
      }
      end)
    }
    report = :xmerl.export_simple([root], :xmerl_xml, prolog: [])
    File.write("generic_coverage.xml", report)
  end

  defp lines(mod) do
    {:ok, lines} = :cover.analyse(mod, :calls, :line)
    lines
    |> Stream.filter(fn {{_m, line}, _hits} -> line != 0 end)
    |> Enum.map(fn {{_m, line}, hits} ->
      # <line branch="false" hits="21" number="76"/>
      covered = if hits == 0, do: "false", else: true
      {:lineToCover, [lineNumber: line, covered: covered], []}
    end)
  end
end
