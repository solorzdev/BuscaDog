class MockPlace {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String kind; // veterinary|hotel|restaurant
  const MockPlace({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.kind,
  });
}

const mockPlaces = <MockPlace>[
  MockPlace(
    id: '1',
    name: 'Vet Centro',
    lat: 20.6736,
    lng: -103.3440,
    kind: 'veterinary',
  ),
  MockPlace(
    id: '2',
    name: 'PetCare Norte',
    lat: 20.6900,
    lng: -103.3600,
    kind: 'veterinary',
  ),
  MockPlace(
    id: '3',
    name: 'Hotel Pet Friendly',
    lat: 20.665,
    lng: -103.35,
    kind: 'hotel',
  ),
];
