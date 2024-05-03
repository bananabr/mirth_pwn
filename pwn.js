var ProcessBuilder = Packages.java.lang.ProcessBuilder;

function executeShellCommand(command) {
    var processBuilder = new ProcessBuilder('bash', '-c', command);
    var process = processBuilder.start();
    process.waitFor();
    return;
}

executeShellCommand('wget http://localhost');
