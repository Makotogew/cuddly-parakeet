Describe "Docker" {
    while($true) {
        $dockerServiceStatus = (Get-Service -Name docker).Status
        if($dockerServiceStatus -ne 'Running') {
            Write-Output "Docker service is $dockerServiceStatus. Waiting for it to be Running"
            Start-Service -Name docker
            Start-Sleep -s 10
        } else {
            Write-Output "Docker service is $dockerServiceStatus."
            break
        }
    }
    It "docker is installed" {
        "docker --version" | Should -ReturnZeroExitCode
    }

    It "docker service is up" {
        "docker images" | Should -ReturnZeroExitCode
    }

    It "docker symlink" {
        "C:\Windows\SysWOW64\docker.exe ps" | Should -ReturnZeroExitCode
    }
}

Describe "DockerCompose" {
    It "docker compose v2" {
        "docker compose version" | Should -ReturnZeroExitCode
    }

}

Describe "DockerWinCred" {
    It "docker-wincred" {
        "docker-credential-wincred version" | Should -ReturnZeroExitCode
    }
}

Describe "DockerImages" -Skip:(Test-IsWin25) {
    while($true) {
        $dockerServiceStatus = (Get-Service -Name docker).Status
        if($dockerServiceStatus -ne 'Running') {
            Write-Output "Docker service is $dockerServiceStatus. Waiting for it to be Running"
            Start-Service -Name docker
            Start-Sleep -s 10
        } else {
            Write-Output "Docker service is $dockerServiceStatus."
            break
        }
    }
    Context "docker images" {
        $testCases = (Get-ToolsetContent).docker.images | ForEach-Object { @{ ImageName = $_ } }

        It "<ImageName>" -TestCases $testCases {
            docker images "$ImageName" --format "{{.Repository}}" | Should -Not -BeNullOrEmpty
        }
    }
}
