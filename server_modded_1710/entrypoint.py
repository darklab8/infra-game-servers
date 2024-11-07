import subprocess
import os

authlib_auth_server = os.environ.get("AUTHLIB_AUTH_SERVER")
authlib_auth_server_arg = ""
if authlib_auth_server:
    authlib_auth_server_arg = f" -javaagent:/code/authlib-injector-snapshot.jar={authlib_auth_server}"

max_ram = os.environ.get("MAX_RAM", "10G")
read_timeout = os.environ.get("READ_TIMEOUT", "120")

enable_jmx_debugger = os.environ.get("ENABLE_JMX_DEBUGGER")
if enable_jmx_debugger:
    jmx_debugger_args = [
        "-Dcom.sun.management.jmxremote",
        "-Djava.net.preferIPv4Stack=true",
        "-Dcom.sun.management.jmxremote.port=25861",
        "-Dcom.sun.management.jmxremote.authenticate=false"
        "-Dcom.sun.management.jmxremote.ssl=false",
        "-Djava.rmi.server.hostname=0.0.0.0",
    ]
else:
    jmx_debugger_args = []


final_command = " ".join(
    [
        "java",
        f"-Xmx{max_ram}",
        f"-Dfml.readTimeout={read_timeout}",
        "-Dfile.encoding=UTF-8",
        # authlib_auth_server_arg,
        # debugger
    ] + jmx_debugger_args + [    
        "-jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar",
    ])

print(f"{final_command=}")

if __name__=="__main__":
    subprocess.run(final_command, shell=True, check=True)
