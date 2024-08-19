import subprocess
import os

authlib_auth_server = os.environ.get("AUTHLIB_AUTH_SERVER")
authlib_auth_server_arg = ""
if authlib_auth_server:
    authlib_auth_server_arg = f" -javaagent:/code/authlib-injector-snapshot.jar={authlib_auth_server}"

max_ram = os.environ.get("MAX_RAM", "10G")
read_timeout = os.environ.get("READ_TIMEOUT", "120")

final_command = " ".join(
    [
        "java",
        f"-Xmx{max_ram}",
        f"-Dfml.readTimeout={read_timeout}",
        "-Dfile.encoding=UTF-8",
        authlib_auth_server_arg,
        "-jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar",
    ])

print(f"{final_command=}")

if __name__=="__main__":
    subprocess.run(final_command, shell=True, check=True)
