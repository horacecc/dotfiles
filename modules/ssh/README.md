# SSH keys

Each SSH key lives in the Mac's Secure Enclave and is unlocked with Touch ID, so
the private key can't be copied off the machine. Each destination gets its own
key, so a server's logs can't be linked to another server's or to the key
GitHub publishes.

A key named `<name>` has the label `ssh-<name>` in the Secure Enclave, and its
files are `~/.ssh/<name>_se` and `~/.ssh/<name>_se.pub`. The file without `.pub`
is only a handle to the key in the Secure Enclave, not the private key.

Use the full paths `/usr/sbin/sc_auth` and `/usr/bin/ssh-keygen`: only Apple's
OpenSSH loads `/usr/lib/ssh-keychain.dylib`, which reaches the Secure Enclave,
and an `ssh-keygen` from Nix or Homebrew earlier in `PATH` doesn't.

## List the keys

```sh
/usr/sbin/sc_auth list-ctk-identities
```

`Public Key Hash` identifies the key in the Secure Enclave; it isn't the SSH
fingerprint that `ssh-keygen -lf` prints. `Label` is cut off after 13
characters. `Valid To` is when the key's self-signed certificate expires; it
isn't known yet whether SSH keeps working after that.

## Make a key

Replace `<name>` with a name of `a-z`, `0-9` and `-`, such as `vps`.

1. Note the fingerprints of the keys that are already there:

   ```sh
   cat ~/.ssh/*_se.pub | ssh-keygen -lf -
   ```

2. Make the key and touch Touch ID:

   ```sh
   /usr/sbin/sc_auth create-ctk-identity -l ssh-<name> -k p-256-ne -t bio
   ```

3. Write its handle. `ssh-keygen -K` writes every key in the Secure Enclave to the
   same `id_ecdsa_sk_rk`, so do it in an empty folder; answering `y` to each
   overwrite keeps the last one, which so far has been the newest:

   ```sh
   cd "$(mktemp -d)"
   yes y | /usr/bin/ssh-keygen -w /usr/lib/ssh-keychain.dylib -K -N ""
   ssh-keygen -lf id_ecdsa_sk_rk.pub
   ```

   The fingerprint must not be one from step 1. If it is, the key written is an
   older one: stop, and don't move it.

4. Move it into place:

   ```sh
   mv -n id_ecdsa_sk_rk ~/.ssh/<name>_se
   mv -n id_ecdsa_sk_rk.pub ~/.ssh/<name>_se.pub
   chmod 600 ~/.ssh/<name>_se
   ```

5. Add the host to `~/.ssh/config`, above the `Host *` entry (see below):

   ```
   Host <name>
     HostName <address>
     User <user>
     IdentityFile ~/.ssh/<name>_se
     IdentitiesOnly yes
     SecurityKeyProvider /usr/lib/ssh-keychain.dylib
   ```

6. Add the contents of `~/.ssh/<name>_se.pub` to the server's
   `~/.ssh/authorized_keys`, or to GitHub.

7. Check that it works. Touch ID should ask, and `-v` should show
   `~/.ssh/<name>_se` being offered:

   ```sh
   ssh -v <name>
   ```

To undo before the server has the key: delete `~/.ssh/<name>_se{,.pub}` and the
`Host` entry, and delete the key from the Secure Enclave (`sc_auth` with no
arguments lists its commands).

## ~/.ssh/config

`~/.ssh/config` stays out of this repo because it has private addresses. End it
with:

```
Host *
  HashKnownHosts yes
```

ssh uses the first value it finds for each option, so `Host *` goes last to
apply only where a host doesn't set its own.

`HashKnownHosts` writes each new host to `~/.ssh/known_hosts` as a hash instead
of its name or address, so the file doesn't list where you connect. Private
addresses are few enough to find by trying them all, so this only slows someone
down. Use `ssh-keygen -F <host>` to find a host and `ssh-keygen -R <host>` to
remove it.

It only hashes hosts added from now on. To hash the ones already there, run:

```sh
ssh-keygen -H
```

and delete `~/.ssh/known_hosts.old`, the backup it leaves with the names still
in it.
