# Recompile Magento 2.4.x

I wrote this script for recompiling my local. It also has a check for which caching engine is used since Adobe Commerce Cloud uses Fastly and a prompt for switching it to Built-In Cache from Fastly.

The recompile.sh can be copied to /usr/bin or other location and chmod 755 so it can execute. You can drop the .sh off of the end as well to make it behave like a shell command.

Example:

```
sudo cp recompile.sh /usr/bin/recompile
sudo chmod 755 /usr/bin/recompile
```

After these commands are run, `recompile` can be executed from any Magento location.
