      await ref.read(seedServiceProvider).wipe();
      await ref.read(seedServiceProvider).seed();
      bumpDataVersion(ref);