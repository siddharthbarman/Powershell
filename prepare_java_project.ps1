# Author: If it works, this was created by Siddharth Barman
# Date  : Jan 28 2020! F*** its 2020 already!!!
# Desc  : Creates simple project folder structure for writing java programs
#         with JUnit support.

param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $path,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $projectName,

    [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$false)]
    [System.Boolean]
    $generateSourceFiles
)

New-Item -Path $path -Name $projectName -ItemType "directory"
$fullPath = "$path\$projectName"
Write-Host $fullPath

New-Item -Path $fullPath -Name "bin" -ItemType "directory"
New-Item -Path $fullPath -Name "lib" -ItemType "directory"
New-Item -Path $fullPath -Name "src" -ItemType "directory"
New-Item -Path "$fullPath\src" -Name "app" -ItemType "directory"
New-Item -Path "$fullPath\src" -Name "test" -ItemType "directory"

Invoke-WebRequest "https://search.maven.org/remotecontent?filepath=junit/junit/4.13/junit-4.13.jar" -O "$fullPath\lib\junit.jar" 
Invoke-WebRequest "https://search.maven.org/remotecontent?filepath=org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar" -O "$fullPath\lib\hamcrest.jar"

if ($generateSourceFiles) {
$appcode = "
package app;
public class Application {
    public static void main(String args[]) {
        System.out.println(new Greeting().getGreeting());
    }
}"
$appcode | Set-Content "$fullPath\src\app\Application.java"

$classcode = "
package app;
public class Greeting {
    public String getGreeting() {
        return ""hello!"";
    }
}"
$classcode | Set-Content "$fullPath\src\app\Greeting.java"

$testcode = "
package test;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import app.*;

public class GreetingTests {
    @Test
    public void testGreeting() {
        assertEquals(""hello!"", new Greeting().getGreeting());
    }
}"
$testcode | Set-Content "$fullPath\src\test\GreetingTests.java"

}

Write-Host "Congratulations! Your Java project folder is ready for VSCode!"
Write-Host "Save the workspace before you start compiling or running tests."

Set-Location -Path $fullPath
code $fullPath
