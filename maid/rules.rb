# Reference: https://github.com/adtaylor/maid-rules/blob/master/rules.rb

require 'digest/md5'

Maid.rules do
  def files(paths)
    dir(paths).select { |f| File.file?(f) }
  end

  def size_of(path)
    File.size(path)
  end

  def checksum_for(path)
    Digest::MD5.hexdigest(File.read(path))
  end

  def dupes_in(paths)
    dupes = []
    files(paths).group_by { |f| size_of(f) }.reject { |s, p| p.length < 2 }.map do |size, candidates|
      dupes += candidates.group_by { |p| checksum_for(p) }.reject { |c, p| p.length < 2 }.values
    end
    dupes
  end

  rule 'Oldest downloads' do
    dir('~/Downloads/*').each do |path|
      trash(path) if 365.day.since?(created_at(path))
    end
  end

  rule 'Old downloads' do
    dir('~/Downloads/*').each do |path|
      trash(path) if 180.day.since?(accessed_at(path))
    end
  end

  rule 'Old ISOs' do
    dir('~/Downloads/*.iso').each do |path|
      trash(path) if 90.day.since?(accessed_at(path))
    end
  end

  rule 'Old Screenshots' do
    dir('~/Documents/Screenshots/*').each do |path|
      trash(path) if 30.day.since?(created_at(path))
    end
  end

  rule 'Screenshots' do
    dir('~/Desktop/Screen Shot *').each do |path|
      if 2.day.since?(created_at(path))
        move(path, '~/Documents/Screenshots/')
      end
    end
  end

  # rule 'Mac OS X applications in zip files' do
  #   found = dir('~/Downloads/*.zip').select { |path|
  #     zipfile_contents(path).any? { |c| c.match(/\.app$/) }
  #   }

  #   trash(found)
  # end

  rule 'added Torrent files (Transmission)' do
    remove(dir('~/Dropbox/torrents/*.added'))
  end

  rule 'Remove expendable files' do
    dir('~/Downloads/*.{csv,pdf,doc,docx,gem,vcs,ics,ppt,js,rb,xml,xlsx}').each do |p|
      trash(p) if 3.days.since?(accessed_at(p))
    end
  end

  rule 'Trash duplicate downloads' do
    dupes_in('~/Downloads/*').each do |dupes|
      # Keep the dupe with the shortest filename
      trash dupes.sort_by { |p| File.basename(p).length }[1..-1]
    end
  end

  # Often archives are unpacked to the Downloads directory. We still have the
  # archive, so get rid of the folder.
  rule 'Remove directories in Downloads' do
    dir(['~/Downloads/*']).each do |p|
      if File.directory?(p) && 2.days.since?(accessed_at(p))
        trash(p)
      end
    end
  end

  rule 'Take out the Trash' do
    dir('~/.Trash/*').each do |p|
      remove(p) if 30.days.since?(accessed_at(p))
    end
  end

  rule 'Take out the Trash' do
    dir('~/.Trash/*').each do |p|
      remove(p) if 180.days.since?(created_at(p))
    end
  end

end
