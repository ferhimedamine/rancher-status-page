#!/bin/sh

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

echo '<table style="width: 60%; margin-top: 20px;" class="table-bordered table-responsive table-condensed;">'
cat <<StartRows
<h3>Infrastructure</h3>
 <tr>
   <th>Hostname</th>
   <th>Cluster</th>
   <th>Instance ID</th>
   <th>Operating System</th>
   <th>Docker Version</th>
  </tr>
StartRows

#Loop over hosts in rancher-metadata to get host info
export result=`curl -s rancher-metadata/latest/hosts`
for host in ${result}; do

    hostname=`echo $host | sed 's/^\d*=//'`
    host_id=`echo $host | awk -F= {'print $1'}`
    name=`curl -s http://rancher-metadata/latest/hosts/${host_id}/name`
    cluster=`curl s- http://rancher-metadata/latest/hosts/${host_id}/labels/cluster-type`
    instance_id=`curl -s http://rancher-metadata/latest/hosts/${host_id}/labels/spotinst.instanceId`
    os_version=`curl s- http://rancher-metadata/latest/hosts/${host_id}/labels/os-version`
    docker_version=`curl -s http://rancher-metadata/latest/hosts/${host_id}/labels/io.rancher.host.docker_version`

    echo "<tr>"
        echo "<td>$hostname</td>"
        echo "<td>${cluster}</td>"
        echo "<td>${instance_id}</td>"
        echo "<td>${os_version}</td>"
        echo "<td>${docker_version}</td>"
    echo "</tr>"
done
echo "</table>"

echo "</div>"
echo '<div class="container" style="margin-top: 20px;">'


# Generate tables
export stacks=`curl -s rancher-metadata/latest/stacks/`

echo "<h3>Stacks</h3>"
echo '<table style="width:100%; margin-top: 20px; margin-bottom: 20px;" class="table-bordered table-responsive table-condensed;">'

cat <<TableHeaders
 <tr>
   <th colspan='5'>Service Name:</th>
   <th colspan='5'>Environment:</th>
   <th colspan='5'>Tag:</th>
   <th colspan='5'>Version SHA:</th>
   <th colspan='3'>Ports:</th>
  </tr>
TableHeaders

for stack in ${stacks}; do
  int=`echo $stack | grep -o "^\d*"`
  containers=`curl -s rancher-metadata/latest/stacks/$int/services/`

  for ind_container in ${containers}; do
    container_name=`echo $ind_container | sed 's/^\d*=//'`

    stack_=`echo $stack | sed 's/^\d*=//'`

    echo "<tr>"
      echo "<td colspan='5'>"
        echo ${stack_}/$container_name
      echo "</td>"

      serv_int=`echo $ind_container | grep -o "^\d*"`
      env_name=`curl -s rancher-metadata/latest/stacks/$int/environment_name`

      echo "<td colspan='5'>"
        echo $env_name
      echo "</td>"

      stack_name=`curl -s rancher-metadata/latest/stacks/$int/services/$serv_int/labels/io.rancher.stack.name`

      #Get Container VCS versions
      VCS_URL=`curl -s rancher-metadata/latest/stacks/${int}/services/${container_name}/labels/org.label-schema.vcs-url | awk -F: {'print $2'} | sed -e s/\.git//g`
      VCS_REF=`curl -s rancher-metadata/latest/stacks/${int}/services/${container_name}/labels/org.label-schema.vcs-ref`
      VCS_URL="https://github.com/${VCS_URL}/commit/${VCS_REF}"

      ports=`curl -s rancher-metadata/latest/stacks/$int/services/$serv_int/ports/`
      port_list=""
      ports_=""
      portmap=""

      for portno in ${ports}; do
          portmap=`curl -s rancher-metadata/latest/stacks/$int/services/$serv_int/ports/$portno`
          port_list="$port_list, $portmap"
          ports_=`echo $port_list | sed 's/,$//'`
          ports_=`echo $ports_ | sed 's/^,//'`
      done

      echo "<td colspan='5'>"
       echo $stack_name
      echo "</td>"

      echo "<td colspan='5'>"
       echo "<a href="${VCS_URL}">${VCS_REF}</a>"
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

