
$elements = @()
$targets = [System.IO.File]::OpenText("C:\Users\kissa\Documents\src\TARGETS.txt")

try {

  for() {

    $line = $targets.ReadLine()
    if( $line -ne $null ) {
      $elements += [NetworkTarget]::new($line)
    } else {
      break
    }    

  }

}

finally {
  $targets.Close()
}

for() {

  foreach( $element in $elements ) {

    Start-Sleep -s 2
    $element.checkConnection()

  }

}

 

Class NetworkTarget {

  [String] $host
  [String] $protocol
  [int] $port

  NetworkTarget([string]$data) {

    $dataArray = $data.split(":")

    $this.host = $dataArray[0]       
    $this.protocol = $dataArray[1]
    $this.port = $dataArray[2]

  }

  [void] checkConnection() {

    $client = $null

    try {

      if( $this.protocol -eq "tcp" ) {
        $client = New-Object Net.Sockets.TcpClient
        $client.Connect($this.host,$this.port)
      } 

    } catch {}

    if( $client.Connected ) {
      $client.Close()
      Write-Host $this.host ":" $this.protocol :  $this.port "is OPEN" -foregroundcolor "green"
    } else {
      Write-Host $this.host ":" $this.protocol :  $this.port "is CLOSED" -foregroundcolor "red"
    }

  }

}