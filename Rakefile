require "net/ftp"
require "yaml"

class FTPClient
  attr_reader :remote_path

  def initialize(remote_path)
    @remote_path = remote_path
  end

  def ftp
    @ftp ||= Net::FTP.new
  end

  def connect
    ftp.connect(credentials["server"])
    ftp.login(credentials["username"], credentials["password"])
    ftp.passive = true
    # ftp.debug_mode = true
    ftp.chdir(remote_path)
  end

  def delete_recursive(file_or_dir)
    if file_or_dir == list(file_or_dir).first
      puts "Removing file: #{file_or_dir}"
      ftp.delete(file_or_dir)
    else
      list(file_or_dir).each { |f| delete_recursive(file_or_dir + "/" + f) }
      puts "Removing directory: #{file_or_dir}"
      ftp.rmdir(file_or_dir)
    end
  end

  def copy_recursive(file_or_dir, prefix_to_remove = nil)
    remote_file_or_dir = prefix_to_remove ? file_or_dir.gsub(prefix_to_remove, "") : file_or_dir
    if File.directory?(file_or_dir)
      puts "Creating directory #{remote_file_or_dir}"
      ftp.mkdir(remote_file_or_dir)
      Dir.glob(file_or_dir + "/*").each { |e| copy_recursive(e, prefix_to_remove) }
    else
      puts "Creating file #{remote_file_or_dir}"
      ftp.putbinaryfile(file_or_dir, remote_file_or_dir)
    end
  end

  # file list
  def list(path = nil)
    ftp.nlst(path).select { |f| f != "." && f != ".." }
  end

  def credentials
    @credentials ||= YAML.load_file("credentials.yaml")
  end
end

class Deployer
  def self.run(local, remote)
    ftp_client = FTPClient.new(remote)
    ftp_client.connect

    # Remove all files
    ftp_client.list.each do |entry|
      ftp_client.delete_recursive(entry)
    end

    # Copy files placed in public directory
    Dir.glob(local + "/*").each do |entry|
      ftp_client.copy_recursive(entry, local + "/")
    end
  ensure
    ftp_client.ftp.close
  end
end

desc "deploy via ftp"
task :deploy do
  Deployer.run("public", "testing")
end
