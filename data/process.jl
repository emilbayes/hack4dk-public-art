# Change dir so Julia will understand the paths
cd(dirname(@__FILE__))

using DataFrames
using DataFramesMeta

artists = readtable("raw/artists.csv",
                    separator = ';',
                    names = [:display_name, :gender, :last_name,
                             :first_name, :display_bio, :birth_year,
                             :death_year])

purchases = readtable("raw/purchases.csv",
                      names = [:id, :art_type, :classification, :display_name,
                               :title, :year, :begin_year, :medium, :dimensions,
                               :current_location])

# # Check missing data
# describe(artists)
# describe(purchases)

# Remove missing gender and normalise remaining genders
deleterows!(artists, find(isna(artists[:gender])))
artists[:gender] = map((g) -> lowercase(g), artists[:gender])

# Fix years by convering 1900 - 2099 to integer, and try and extract year from
# id on remaining rows. Return NA if all fails
function fixyear (row)
  year_exp = r"^(19|20)[0-9]{2}$"
  if ismatch(year_exp, string(row[:year]))
    return int(row[:year])
  else
    year_candidate = split(row[:id], '-')[2]
    if ismatch(year_exp, year_candidate)
      return int(year_candidate)
    else
      return NA
    end
  end
end
purchases[:year] = map(fixyear, eachrow(purchases))

# Ignore remaining NA for now
complete_cases!(purchases)

joined = join(purchases, artists, on = :display_name, kind = :semi)
writetable("refined-data/artists-purchases.csv", joined, nastring = "")
