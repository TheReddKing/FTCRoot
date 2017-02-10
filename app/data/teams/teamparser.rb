files = Dir["*.tsv"]
for file in files
    puts file
    File.read(file).each_line do |line|
        spl = line.split("\t")
        print "{\"id\":\"#{spl[2]}\",\"contact_email\":\"#{spl[3]}\""
        if spl[4].length > 0
            print ",\"blurb\":\"#{spl[4].gsub("\"","\\\"")}\""
        end
        if spl[5].length > 0
            print ",\"website\":\"#{spl[5]}\""
        end
        if spl[6].length > 0
            print ",\"contact_twitter\":\"#{spl[6].gsub("@","")}\""
        end
        if spl[7].length > 0
            print ",\"contact_youtube\":\"#{spl[7]}\""
        end
        if spl[8].length > 0
            print ",\"contact_facebook\":\"#{spl[8]}\""
        end
        puts "}"
    end
end
puts "DONE"
