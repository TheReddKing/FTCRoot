import csv, sys
import cgi
import json
filename = 'some.csv'
import glob
for file in glob.glob("*.csv"):
    print(file)
    filename = file #find first csv file
    break
updatefile = open("allteams.update","w")

with open(filename, 'rb') as f:
    reader = csv.reader(f)
    try:
        for row in reader:
            # print row
            dict = {}
            dict['id'] = row[2]
            dict["contact_email"] = row[3]
            if row[4]:
                dict["blurb"] = cgi.escape(row[4]).replace("\n","<br/>")
            if row[5]:
                dict["website"] = row[5]
            if row[6]:
                dict["contact_twitter"] = row[6]
            if row[7]:
                dict["contact_youtube"] = row[7]
            if row[8]:
                dict["contact_facebook"] = row[8]
            updatefile.write(json.dumps(dict) + "\n")
            # updatefile.write(("""{{"id":"{}", "contact_email":"{}" """).format(row[2],row[3]))
            # if row[4]:
            #     updatefile.write((""", "blurb":"{}" """).format(cgi.escape(row[4]).replace("\n","<br/>")))
            # if row[5]:
            #     updatefile.write((""", "website":"{}" """).format(row[5]))
            #
            # if row[6]:
            #     updatefile.write((""", "contact_twitter":"{}" """).format(row[6]))
            # if row[7]:
            #     updatefile.write((""", "contact_youtube":"{}" """).format(row[7]))
            # if row[8]:
            #     updatefile.write((""", "contact_facebook":"{}" """).format(row[8]))
            # updatefile.write("}\n")
    except csv.Error as e:
        sys.exit('file %s, line %d: %s' % (filename, reader.line_num, e))

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
