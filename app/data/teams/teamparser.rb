# require "CSV"
# require "CGI"
# files = Dir["*.csv"]
# for file in files
#     puts file
#     csv = CSV.new(File.read(file))
#     # puts csv.to_a
#     csv.to_a.each do |line|
#         # puts csv.to_a
#         # puts line
#         spl = line
#         # spl = line.split("\t")
#         print "{\"id\":\"#{spl[2]}\",\"contact_email\":\"#{spl[3]}\""
#         if spl[4] and spl[4].length > 0
#             print ",\"blurb\":\"#{CGI.escapeHTML(spl[4].gsub("\"","\\\"")).gsub("\n","<br/>")}\""
#         end
#         if spl[5] and spl[5].length > 0
#             print ",\"website\":\"#{spl[5]}\""
#         end
#         if spl[6] and spl[6].length > 0
#             print ",\"contact_twitter\":\"#{spl[6].gsub("@","")}\""
#         end
#         if spl[7] and spl[7].length > 0
#             print ",\"contact_youtube\":\"#{spl[7]}\""
#         end
#         if spl[8] and spl[8].length > 0
#             print ",\"contact_facebook\":\"#{spl[8]}\""
#         end
#         puts "}"
#     end
# end
# puts "DONE"
