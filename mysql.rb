require 'pg'
require 'json'
require 'open-uri'

#connect to postgres database on heroku 
con = PG.connect :dbname => 'dakvjenroh6bs8', :user => 'wsfxsporhicczg', :password => '0P2B-Jg4GQ5BjP1CuB270ZI0y4', :host =>'ec2-107-21-219-235.compute-1.amazonaws.com'

#fatch data from data sourse api and store into a variable
result = JSON.parse(open("https://cdph.data.ca.gov/api/views/yijp-bauh/rows.json?accessType=DOWNLOAD").read)

#drop table if exists
con.exec("DROP TABLE MYSQLTABLE")

#creating table
puts "Creating Table..."
create_table="CREATE TABLE IF NOT EXISTS MYSQLTABLE(index INTEGER PRIMARY KEY, year INTEGER,sex TEXT)"
con.exec(create_table)
#con.exec("DELETE FROM MYSQLTABLE")

#inserting rows into table
puts "Inserting values into SQLTABLE..."
$i=1
while $i < 110 do

    $year=result["data"][$i][10]
    $sex=result["data"][$i][11]
    insert_table="INSERT INTO MYSQLTABLE VALUES('#{$i}','#{$year}','#{$sex}')"
    con.exec(insert_table)
    $i+=1

end
puts "Values inserted into SQLTABLE successfully..."

puts "Enter Index you want to retrieve.."
$index=gets.chomp

#fatching data from table
fatchById="SELECT * FROM MYSQLTABLE WHERE index=#{$index}"

rs=con.exec(fatchById)

my_results = {}

rs.each do |row|
     my_results["Index"] = row['index']
  my_results["Year"] = row['year']
  my_results["Sex"] = row['sex']
end

 
puts my_results

puts "Enter a year to get data of that year.."
$year=gets.chomp

fatchByYear = "SELECT * FROM MYSQLTABLE WHERE year=#{$year}"

rs1=con.exec(fatchByYear)

results={}

rs1.each do |row|
    results["Index"]=row['index']
  results["Year"] = row['year']
  results["Sex"] = row['sex']
  puts results
end

