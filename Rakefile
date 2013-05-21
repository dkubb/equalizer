require 'devtools'
Devtools.init_rake_tasks

class Rake::Task
  def overwrite(&block)
    @actions.clear
    enhance(&block)
  end
end

Rake.application.load_imports

Rake::Task['metrics:mutant'].overwrite do
  $stderr.puts 'Mutant is disabled, as it directly uses equalizer to kill mutations'
  $stderr.puts 'This issue will be addressed with mutants "Zombie" runtime-namespace-vendoring'
end
