# Force the use of JUnit 4.8.2, which we're using with Maven.
# Buildr 1.4.4 defaults to 4.7.
Buildr.settings.build['junit'] = '4.8.2'

desc 'A simple project for testing whether incremental builds work properly.'
define 'java-build-test' do
  project.group = 'net.emilsit'
  project.version = '1.0.0'
  package :jar, :id => 'java-build-test'
end
