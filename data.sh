#!/bin/sh

export result=`curl -s rancher-metadata/latest/hosts`

cat <<HEADER
<!DOCTYPE html>
<html>
<head>
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <style>
     tr:nth-child(even) {
       background-color: #d9edf7;
     }
     th, td {
         padding-left: 5px;
     }
  </style>
</head>
<body>
<div class="container" style="margin-top: 20px;">
HEADER

echo '<table style="width: 20%; margin-top: 20px;" class="table-bordered table-responsive table-condensed;">'
cat <<StartRows
 <tr>
   <th>Hosts:</th>
  </tr>
StartRows

for host in ${result}; do

    hostname=`echo $host | sed 's/\d*=//'`
    echo "<tr>"
      echo "<td>"
        echo $hostname
      echo "</td>"
    echo "</tr>"
done
echo "</table>"

echo "</div>"
echo '<div class="container" style="margin-top: 20px;">'


# Generate tables
export stacks=`curl -s rancher-metadata/latest/stacks/`
    
echo '<table style="width:100%; margin-top: 20px; margin-bottom: 20px;" class="table-bordered table-responsive table-condensed;">'

cat <<TableHeaders
 <tr>
   <th colspan='5'>Service Name:</th>
   <th colspan='5'>Environment:</th>
   <th colspan='5'>Tag:</th>
   <th colspan='3'>Ports:</th>
  </tr>
TableHeaders

for stack in ${stacks}; do
  int=`echo $stack | grep -o "\d*"`
  containers=`curl -s rancher-metadata/latest/stacks/$int/services/`
    
  for ind_container in ${containers}; do
    container_name=`echo $ind_container | sed 's/\d*=//'`
    echo "<tr>"
      echo "<td colspan='5'>"
        echo $container_name
      echo "</td>"

      serv_int=`echo $ind_container | grep -o "\d*"`
      env_name=`curl -s rancher-metadata/latest/stacks/$int/environment_name`

      echo "<td colspan='5'>"
        echo $env_name
      echo "</td>"

      stack_name=`curl -s rancher-metadata/latest/stacks/$int/services/$serv_int/labels/io.rancher.stack.name`

      for portno in ${ports}; do
          portmap=`curl -s rancher-metadata/latest/stacks/$int/services/$serv_int/ports/$portno`
          port_list="$portmap,"
          ports_=`echo $port_list | sed 's/,$//'`
      done

      echo "<td colspan='5'>"
       echo $stack_name
      echo "</td>"

      echo "<td colspan='3'>"
       echo $ports_
      echo "</td>"

    echo "</tr>"
  done
done

echo "</table>"
echo "</div>"
echo "</body>"
echo "</html>"

