require 'net/ssh'

task default: %w[test]


phone_ip = "192.168.4.136"

task :test do
  puts "Hello world"
end

desc "SSH into jailbreak server"
task :replace_deb do
  Net::SSH.start(phone_ip, "root") do |ssh|
    puts ssh.exec! "ls -al"
  end

end
