# Generated by the protocol buffer compiler.  DO NOT EDIT!

from google.protobuf import descriptor
from google.protobuf import message
from google.protobuf import reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)



DESCRIPTOR = descriptor.FileDescriptor(
  name='anim.proto',
  package='poem',
  serialized_pb='\n\nanim.proto\x12\x04poem\"2\n\x04Rect\x12\t\n\x01x\x18\x01 \x02(\x02\x12\t\n\x01y\x18\x02 \x02(\x02\x12\t\n\x01w\x18\x03 \x02(\x02\x12\t\n\x01h\x18\x04 \x02(\x02\"\x1d\n\x05Point\x12\t\n\x01x\x18\x01 \x02(\x02\x12\t\n\x01y\x18\x02 \x02(\x02\"(\n\x05\x43olor\x12\t\n\x01r\x18\x01 \x02(\x05\x12\t\n\x01g\x18\x02 \x02(\x05\x12\t\n\x01\x62\x18\x03 \x02(\x05\"\xf8\x03\n\x07\x45lement\x12\'\n\x04type\x18\x01 \x02(\x0e\x32\x19.poem.Element.ElementType\x12\x1d\n\x08position\x18\x02 \x02(\x0b\x32\x0b.poem.Point\x12\x1f\n\x0b\x62oundingBox\x18\x03 \x02(\x0b\x32\n.poem.Rect\x12\x0f\n\x07libName\x18\x04 \x01(\t\x12\x14\n\x0cinstanceName\x18\x05 \x01(\t\x12\x10\n\x08rotation\x18\x06 \x01(\x02\x12 \n\x0b\x61nchorPoint\x18\x07 \x01(\x0b\x32\x0b.poem.Point\x12\x1f\n\nscaleValue\x18\x08 \x01(\x0b\x32\x0b.poem.Point\x12\x12\n\x05\x61lpha\x18\t \x01(\x05:\x03\x32\x35\x35\x12\x1a\n\x05\x63olor\x18\n \x01(\x0b\x32\x0b.poem.Color\x12\x0c\n\x04text\x18\x0b \x01(\t\x12\x14\n\x08\x66ontSize\x18\x0c \x01(\x05:\x02\x31\x32\x12\x0b\n\x03\x66nt\x18\r \x01(\t\x12\x11\n\talignment\x18\x0e \x01(\x05\x12\x19\n\x04skew\x18\x0f \x01(\x0b\x32\x0b.poem.Point\"y\n\x0b\x45lementType\x12\x10\n\x0cND_MOVIECLIP\x10\x01\x12\r\n\tND_BITMAP\x10\x02\x12\x0e\n\nND_TTFTEXT\x10\x04\x12\x0c\n\x08ND_FRAME\x10\x07\x12\x0b\n\x07ND_RECT\x10\x08\x12\r\n\tND_BMTEXT\x10\t\x12\x0f\n\x0bND_PARTICLE\x10\x0b\"}\n\x08Keyframe\x12\x12\n\nstartFrame\x18\x01 \x02(\x05\x12\x17\n\x08isMotion\x18\x05 \x01(\x08:\x05\x66\x61lse\x12\x1f\n\x08\x65lements\x18\x03 \x03(\x0b\x32\r.poem.Element\x12\x13\n\x08\x64uration\x18\x04 \x01(\x05:\x01\x31\x12\x0e\n\x06script\x18\x06 \x01(\t\"8\n\x05Layer\x12!\n\tkeyframes\x18\x01 \x03(\x0b\x32\x0e.poem.Keyframe\x12\x0c\n\x04name\x18\x02 \x01(\t\"\x84\x01\n\x11\x41nimationKeyframe\x12\x12\n\nstartFrame\x18\x01 \x02(\x05\x12\x17\n\x08isMotion\x18\x02 \x01(\x08:\x05\x66\x61lse\x12\x1d\n\x08position\x18\x03 \x02(\x0b\x32\x0b.poem.Point\x12\x13\n\x08\x64uration\x18\x04 \x01(\x05:\x01\x31\x12\x0e\n\x06script\x18\x05 \x01(\t\"7\n\tAnimation\x12*\n\tkeyframes\x18\x01 \x03(\x0b\x32\x17.poem.AnimationKeyframe\"\xad\x01\n\x06Symbol\x12\x0c\n\x04name\x18\x01 \x02(\t\x12\x1f\n\x0b\x62oundingBox\x18\x02 \x02(\x0b\x32\n.poem.Rect\x12\x12\n\nframeCount\x18\x03 \x02(\x05\x12\x1b\n\x06layers\x18\x05 \x03(\x0b\x32\x0b.poem.Layer\x12\x1d\n\x04\x61nis\x18\t \x03(\x0b\x32\x0f.poem.Animation\x12\x11\n\tframeRate\x18\n \x01(\x05\x12\x11\n\tpauseTime\x18\x0b \x01(\x02\"%\n\x04\x41nim\x12\x1d\n\x07symbols\x18\x01 \x03(\x0b\x32\x0c.poem.Symbol\".\n\rAnimIndexItem\x12\x0c\n\x04name\x18\x01 \x02(\t\x12\x0f\n\x07symbols\x18\x02 \x03(\t\"/\n\tAnimIndex\x12\"\n\x05\x61nims\x18\x01 \x03(\x0b\x32\x13.poem.AnimIndexItem\"d\n\x05\x46rame\x12\x0c\n\x04name\x18\x01 \x02(\t\x12\t\n\x01x\x18\x02 \x02(\x05\x12\t\n\x01y\x18\x03 \x02(\x05\x12\t\n\x01w\x18\x04 \x02(\x05\x12\t\n\x01h\x18\x05 \x02(\x05\x12\x0f\n\x07rotated\x18\x06 \x02(\x08\x12\x10\n\x08\x66ilename\x18\x07 \x02(\x05\";\n\tFrameList\x12\x1b\n\x06\x66rames\x18\x01 \x03(\x0b\x32\x0b.poem.Frame\x12\x11\n\tfilenames\x18\x02 \x03(\tB\x02H\x03')



_ELEMENT_ELEMENTTYPE = descriptor.EnumDescriptor(
  name='ElementType',
  full_name='poem.Element.ElementType',
  filename=None,
  file=DESCRIPTOR,
  values=[
    descriptor.EnumValueDescriptor(
      name='ND_MOVIECLIP', index=0, number=1,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_BITMAP', index=1, number=2,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_TTFTEXT', index=2, number=4,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_FRAME', index=3, number=7,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_RECT', index=4, number=8,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_BMTEXT', index=5, number=9,
      options=None,
      type=None),
    descriptor.EnumValueDescriptor(
      name='ND_PARTICLE', index=6, number=11,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=529,
  serialized_end=650,
)


_RECT = descriptor.Descriptor(
  name='Rect',
  full_name='poem.Rect',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='x', full_name='poem.Rect.x', index=0,
      number=1, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='y', full_name='poem.Rect.y', index=1,
      number=2, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='w', full_name='poem.Rect.w', index=2,
      number=3, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='h', full_name='poem.Rect.h', index=3,
      number=4, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=20,
  serialized_end=70,
)


_POINT = descriptor.Descriptor(
  name='Point',
  full_name='poem.Point',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='x', full_name='poem.Point.x', index=0,
      number=1, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='y', full_name='poem.Point.y', index=1,
      number=2, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=72,
  serialized_end=101,
)


_COLOR = descriptor.Descriptor(
  name='Color',
  full_name='poem.Color',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='r', full_name='poem.Color.r', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='g', full_name='poem.Color.g', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='b', full_name='poem.Color.b', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=103,
  serialized_end=143,
)


_ELEMENT = descriptor.Descriptor(
  name='Element',
  full_name='poem.Element',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='type', full_name='poem.Element.type', index=0,
      number=1, type=14, cpp_type=8, label=2,
      has_default_value=False, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='position', full_name='poem.Element.position', index=1,
      number=2, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='boundingBox', full_name='poem.Element.boundingBox', index=2,
      number=3, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='libName', full_name='poem.Element.libName', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='instanceName', full_name='poem.Element.instanceName', index=4,
      number=5, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='rotation', full_name='poem.Element.rotation', index=5,
      number=6, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='anchorPoint', full_name='poem.Element.anchorPoint', index=6,
      number=7, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='scaleValue', full_name='poem.Element.scaleValue', index=7,
      number=8, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='alpha', full_name='poem.Element.alpha', index=8,
      number=9, type=5, cpp_type=1, label=1,
      has_default_value=True, default_value=255,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='color', full_name='poem.Element.color', index=9,
      number=10, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='text', full_name='poem.Element.text', index=10,
      number=11, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='fontSize', full_name='poem.Element.fontSize', index=11,
      number=12, type=5, cpp_type=1, label=1,
      has_default_value=True, default_value=12,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='fnt', full_name='poem.Element.fnt', index=12,
      number=13, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='alignment', full_name='poem.Element.alignment', index=13,
      number=14, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='skew', full_name='poem.Element.skew', index=14,
      number=15, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _ELEMENT_ELEMENTTYPE,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=146,
  serialized_end=650,
)


_KEYFRAME = descriptor.Descriptor(
  name='Keyframe',
  full_name='poem.Keyframe',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='startFrame', full_name='poem.Keyframe.startFrame', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='isMotion', full_name='poem.Keyframe.isMotion', index=1,
      number=5, type=8, cpp_type=7, label=1,
      has_default_value=True, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='elements', full_name='poem.Keyframe.elements', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='duration', full_name='poem.Keyframe.duration', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='script', full_name='poem.Keyframe.script', index=4,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=652,
  serialized_end=777,
)


_LAYER = descriptor.Descriptor(
  name='Layer',
  full_name='poem.Layer',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='keyframes', full_name='poem.Layer.keyframes', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='name', full_name='poem.Layer.name', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=779,
  serialized_end=835,
)


_ANIMATIONKEYFRAME = descriptor.Descriptor(
  name='AnimationKeyframe',
  full_name='poem.AnimationKeyframe',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='startFrame', full_name='poem.AnimationKeyframe.startFrame', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='isMotion', full_name='poem.AnimationKeyframe.isMotion', index=1,
      number=2, type=8, cpp_type=7, label=1,
      has_default_value=True, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='position', full_name='poem.AnimationKeyframe.position', index=2,
      number=3, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='duration', full_name='poem.AnimationKeyframe.duration', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='script', full_name='poem.AnimationKeyframe.script', index=4,
      number=5, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=838,
  serialized_end=970,
)


_ANIMATION = descriptor.Descriptor(
  name='Animation',
  full_name='poem.Animation',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='keyframes', full_name='poem.Animation.keyframes', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=972,
  serialized_end=1027,
)


_SYMBOL = descriptor.Descriptor(
  name='Symbol',
  full_name='poem.Symbol',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='name', full_name='poem.Symbol.name', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='boundingBox', full_name='poem.Symbol.boundingBox', index=1,
      number=2, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='frameCount', full_name='poem.Symbol.frameCount', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='layers', full_name='poem.Symbol.layers', index=3,
      number=5, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='anis', full_name='poem.Symbol.anis', index=4,
      number=9, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='frameRate', full_name='poem.Symbol.frameRate', index=5,
      number=10, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='pauseTime', full_name='poem.Symbol.pauseTime', index=6,
      number=11, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1030,
  serialized_end=1203,
)


_ANIM = descriptor.Descriptor(
  name='Anim',
  full_name='poem.Anim',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='symbols', full_name='poem.Anim.symbols', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1205,
  serialized_end=1242,
)


_ANIMINDEXITEM = descriptor.Descriptor(
  name='AnimIndexItem',
  full_name='poem.AnimIndexItem',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='name', full_name='poem.AnimIndexItem.name', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='symbols', full_name='poem.AnimIndexItem.symbols', index=1,
      number=2, type=9, cpp_type=9, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1244,
  serialized_end=1290,
)


_ANIMINDEX = descriptor.Descriptor(
  name='AnimIndex',
  full_name='poem.AnimIndex',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='anims', full_name='poem.AnimIndex.anims', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1292,
  serialized_end=1339,
)


_FRAME = descriptor.Descriptor(
  name='Frame',
  full_name='poem.Frame',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='name', full_name='poem.Frame.name', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='x', full_name='poem.Frame.x', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='y', full_name='poem.Frame.y', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='w', full_name='poem.Frame.w', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='h', full_name='poem.Frame.h', index=4,
      number=5, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='rotated', full_name='poem.Frame.rotated', index=5,
      number=6, type=8, cpp_type=7, label=2,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='filename', full_name='poem.Frame.filename', index=6,
      number=7, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1341,
  serialized_end=1441,
)


_FRAMELIST = descriptor.Descriptor(
  name='FrameList',
  full_name='poem.FrameList',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    descriptor.FieldDescriptor(
      name='frames', full_name='poem.FrameList.frames', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    descriptor.FieldDescriptor(
      name='filenames', full_name='poem.FrameList.filenames', index=1,
      number=2, type=9, cpp_type=9, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=1443,
  serialized_end=1502,
)

_ELEMENT.fields_by_name['type'].enum_type = _ELEMENT_ELEMENTTYPE
_ELEMENT.fields_by_name['position'].message_type = _POINT
_ELEMENT.fields_by_name['boundingBox'].message_type = _RECT
_ELEMENT.fields_by_name['anchorPoint'].message_type = _POINT
_ELEMENT.fields_by_name['scaleValue'].message_type = _POINT
_ELEMENT.fields_by_name['color'].message_type = _COLOR
_ELEMENT.fields_by_name['skew'].message_type = _POINT
_ELEMENT_ELEMENTTYPE.containing_type = _ELEMENT;
_KEYFRAME.fields_by_name['elements'].message_type = _ELEMENT
_LAYER.fields_by_name['keyframes'].message_type = _KEYFRAME
_ANIMATIONKEYFRAME.fields_by_name['position'].message_type = _POINT
_ANIMATION.fields_by_name['keyframes'].message_type = _ANIMATIONKEYFRAME
_SYMBOL.fields_by_name['boundingBox'].message_type = _RECT
_SYMBOL.fields_by_name['layers'].message_type = _LAYER
_SYMBOL.fields_by_name['anis'].message_type = _ANIMATION
_ANIM.fields_by_name['symbols'].message_type = _SYMBOL
_ANIMINDEX.fields_by_name['anims'].message_type = _ANIMINDEXITEM
_FRAMELIST.fields_by_name['frames'].message_type = _FRAME
DESCRIPTOR.message_types_by_name['Rect'] = _RECT
DESCRIPTOR.message_types_by_name['Point'] = _POINT
DESCRIPTOR.message_types_by_name['Color'] = _COLOR
DESCRIPTOR.message_types_by_name['Element'] = _ELEMENT
DESCRIPTOR.message_types_by_name['Keyframe'] = _KEYFRAME
DESCRIPTOR.message_types_by_name['Layer'] = _LAYER
DESCRIPTOR.message_types_by_name['AnimationKeyframe'] = _ANIMATIONKEYFRAME
DESCRIPTOR.message_types_by_name['Animation'] = _ANIMATION
DESCRIPTOR.message_types_by_name['Symbol'] = _SYMBOL
DESCRIPTOR.message_types_by_name['Anim'] = _ANIM
DESCRIPTOR.message_types_by_name['AnimIndexItem'] = _ANIMINDEXITEM
DESCRIPTOR.message_types_by_name['AnimIndex'] = _ANIMINDEX
DESCRIPTOR.message_types_by_name['Frame'] = _FRAME
DESCRIPTOR.message_types_by_name['FrameList'] = _FRAMELIST

class Rect(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RECT
  
  # @@protoc_insertion_point(class_scope:poem.Rect)

class Point(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _POINT
  
  # @@protoc_insertion_point(class_scope:poem.Point)

class Color(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _COLOR
  
  # @@protoc_insertion_point(class_scope:poem.Color)

class Element(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ELEMENT
  
  # @@protoc_insertion_point(class_scope:poem.Element)

class Keyframe(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _KEYFRAME
  
  # @@protoc_insertion_point(class_scope:poem.Keyframe)

class Layer(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _LAYER
  
  # @@protoc_insertion_point(class_scope:poem.Layer)

class AnimationKeyframe(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ANIMATIONKEYFRAME
  
  # @@protoc_insertion_point(class_scope:poem.AnimationKeyframe)

class Animation(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ANIMATION
  
  # @@protoc_insertion_point(class_scope:poem.Animation)

class Symbol(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _SYMBOL
  
  # @@protoc_insertion_point(class_scope:poem.Symbol)

class Anim(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ANIM
  
  # @@protoc_insertion_point(class_scope:poem.Anim)

class AnimIndexItem(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ANIMINDEXITEM
  
  # @@protoc_insertion_point(class_scope:poem.AnimIndexItem)

class AnimIndex(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ANIMINDEX
  
  # @@protoc_insertion_point(class_scope:poem.AnimIndex)

class Frame(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _FRAME
  
  # @@protoc_insertion_point(class_scope:poem.Frame)

class FrameList(message.Message):
  __metaclass__ = reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _FRAMELIST
  
  # @@protoc_insertion_point(class_scope:poem.FrameList)

# @@protoc_insertion_point(module_scope)
