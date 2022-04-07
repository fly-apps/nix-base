{ fly
, busybox
, cacert
}:

/**
 * Minimum basic requirements.
 *
 * Usage of `busybox` assumes a shell is needed (it generally is for POSIX `/bin/sh`).
 * Usage of `cacert` is needed for SSL certificates.
 *
 * Adding to this layer affects every default Fly image templates.
 */
fly.imageTools.buildSpecifiedLayers {
  layeredContent = [
    { contents = [ busybox cacert ]; }
  ];
}
