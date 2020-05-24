# fio-test-scaffolding

# WARNING WARNING WARNING

These test scripts are **dangerous** and should not be casually run by people who don't know exactly what they're doing!
They assume that they're in a system where any Ironwolf 12TB drive is a device under test and can be casually repartitioned, added to or removed from mdraid arrays or ZFS pools **without any warning** and they'll do exactly that.

They similarly assume that any mdraid array under **/dev/md1** and any ZFS pool named **test** are devices under test, fair game, and can be destroyed, recreated, or otherwise mangled **without any warnings**.

These scripts are a place to start from, and will not be ready for use as-is on nearly any individual system. **Do not use these scripts on production systems.**

# WARNING WARNING WARNING

----

This is the scripting that was used to generate benchmarks published at https://arstechnica.com/gadgets/2020/05/zfs-versus-raid-eight-ironwolf-disks-two-filesystems-one-winner/

Currently a bit of a chocolate mess; was not designed from the get-go for public consumption. The perl script on the inside of the loop's not bad, but don't judge me too harshly by the quick-and-dirty bash scripting that calls it. =)
