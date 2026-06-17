import 'poketmon.dart';

// 1세대 포켓몬 151마리의 압축 데이터 (한글명|영문명|타입)
final List<String> _gen1RawData = [
  "이상해씨|Bulbasaur|풀,독", "이상해풀|Ivysaur|풀,독", "이상해꽃|Venusaur|풀,독",
  "파이리|Charmander|불", "리자드|Charmeleon|불", "리자몽|Charizard|불,비행",
  "꼬부기|Squirtle|물", "어니부기|Wartortle|물", "거북왕|Blastoise|물",
  "캐터피|Caterpie|벌레", "단데기|Metapod|벌레", "버터플|Butterfree|벌레,비행",
  "뿔충이|Weedle|벌레,독", "딱충이|Kakuna|벌레,독", "독침붕|Beedrill|벌레,독",
  "구구|Pidgey|노말,비행", "피죤|Pidgeotto|노말,비행", "피죤투|Pidgeot|노말,비행",
  "꼬렛|Rattata|노말", "레트라|Raticate|노말", "깨비참|Spearow|노말,비행",
  "깨비드릴조|Fearow|노말,비행", "아보|Ekans|독", "아보크|Arbok|독",
  "피카츄|Pikachu|전기", "라이츄|Raichu|전기", "모래두지|Sandshrew|땅",
  "고지|Sandslash|땅", "니드런(암컷)|Nidoran((femail)|독", "니드러나|Nidorina|독",
  "니드퀸|Nidoqueen|독,땅", "니드런(수컷)|Nidoran(mail)|독", "니드리노|Nidorino|독",
  "니드킹|Nidoking|독,땅", "삐삐|Clefairy|페어리", "픽시|Clefable|페어리",
  "식스테일|Vulpix|불", "나인테일|Ninetales|불", "푸린|Jigglypuff|노말,페어리",
  "푸크린|Wigglytuff|노말,페어리", "주뱃|Zubat|독,비행", "골뱃|Golbat|독,비행",
  "뚜벅초|Oddish|풀,독", "냄새꼬|Gloom|풀,독", "라플레시아|Vileplume|풀,독",
  "파라스|Paras|벌레,풀", "파라섹트|Parasect|벌레,풀", "콘팡|Venonat|벌레,독",
  "도나리|Venomoth|벌레,독", "디그다|Diglett|땅", "닥트리오|Dugtrio|땅",
  "나옹|Meowth|노말", "페르시온|Persian|노말", "고라파덕|Psyduck|물",
  "골덕|Golduck|물", "망키|Mankey|격투", "성원숭|Primeape|격투",
  "가디|Growlithe|불", "윈디|Arcanine|불", "발챙이|Poliwag|물",
  "슈륙챙이|Poliwhirl|물", "강챙이|Poliwrath|물,격투", "케이시|Abra|에스퍼",
  "윤겔라|Kadabra|에스퍼", "후딘|Alakazam|에스퍼", "알통몬|Machop|격투",
  "근육몬|Machoke|격투", "괴력몬|Machamp|격투", "모다피|Bellsprout|풀,독",
  "우츠동|Weepinbell|풀,독", "우츠보트|Victreebel|풀,독", "왕눈해|Tentacool|물,독",
  "독파리|Tentacruel|물,독", "꼬마돌|Geodude|바위,땅", "데구리|Graveler|바위,땅",
  "딱구리|Golem|바위,땅", "포니타|Ponyta|불", "날쌩마|Rapidash|불",
  "야돈|Slowpoke|물,에스퍼", "야도란|Slowbro|물,에스퍼", "코일|Magnemite|전기,강철",
  "레어코일|Magneton|전기,강철", "파오리|Farfetch'd|노말,비행", "두두|Doduo|노말,비행",
  "두트리오|Dodrio|노말,비행", "쥬쥬|Seel|물", "쥬레곤|Dewgong|물,얼음",
  "질퍽이|Grimer|독", "질뻐기|Muk|독", "셀러|Shellder|물",
  "파르셀|Cloyster|물,얼음", "고오스|Gastly|고스트,독", "고우스트|Haunter|고스트,독",
  "팬텀|Gengar|고스트,독", "롱스톤|Onix|바위,땅", "슬리프|Drowzee|에스퍼",
  "슬리퍼|Hypno|에스퍼", "크랩|Krabby|물", "킹크랩|Kingler|물",
  "찌리리공|Voltorb|전기", "붐볼|Electrode|전기", "아라리|Exeggcute|풀,에스퍼",
  "나시|Exeggutor|풀,에스퍼", "탕구리|Cubone|땅", "텅구리|Marowak|땅",
  "시라소몬|Hitmonlee|격투", "홍수몬|Hitmonchan|격투", "내루미|Lickitung|노말",
  "또가스|Koffing|독", "또도가스|Weezing|독", "뿔카노|Rhyhorn|땅,바위",
  "코뿌리|Rhydon|땅,바위", "럭키|Chansey|노말", "덩쿠리|Tangela|풀",
  "캥카|Kangaskhan|노말", "쏘드라|Horsea|물", "시드라|Seadra|물",
  "콘치|Goldeen|물", "왕콘치|Seaking|물", "별가사리|Staryu|물",
  "아쿠스타|Starmie|물,에스퍼", "마임맨|Mr. Mime|에스퍼,페어리", "스라크|Scyther|벌레,비행",
  "루주라|Jynx|얼음,에스퍼", "에레브|Electabuzz|전기", "마그마|Magmar|불",
  "쁘사이저|Pinsir|벌레", "켄타로스|Tauros|노말", "잉어킹|Magikarp|물",
  "갸라도스|Gyarados|물,비행", "라프라스|Lapras|물,얼음", "메타몽|Ditto|노말",
  "이브이|Eevee|노말", "샤미드|Vaporeon|물", "쥬피썬더|Jolteon|전기",
  "부스터|Flareon|불", "폴리곤|Porygon|노말", "암나이트|Omanyte|바위,물",
  "암스타|Omastar|바위,물", "투구|Kabuto|바위,물", "투구푸스|Kabutops|바위,물",
  "프테라|Aerodactyl|바위,비행", "잠만보|Snorlax|노말", "프리져|Articuno|얼음,비행",
  "썬더|Zapdos|전기,비행", "파이어|Moltres|불,비행", "미뇽|Dratini|드래곤",
  "신뇽|Dragonair|드래곤", "망나뇽|Dragonite|드래곤,비행", "뮤츠|Mewtwo|에스퍼",
  "뮤|Mew|에스퍼"
];

// 압축된 데이터를 풀어서 151마리의 리스트를 완성하는 함수
final List<Pokemon> gen1Pokemon = List.generate(151, (index) {
  final int id = index + 1;

  // '|' 기호를 기준으로 한글명, 영문명, 타입을 쪼개기
  final List<String> parts = _gen1RawData[index].split('|');
  final String name = parts[0];
  final String nameEn = parts[1];

  // ',' 기호를 기준으로 복수 타입(예: 풀,독)을 List로 쪼개기
  final List<String> types = parts[2].split(',');

  return Pokemon(
    id: id,
    name: name,
    nameEn: nameEn,
    types: types,
    description: '1세대 도감 번호 No.${id.toString().padLeft(3, '0')} $name입니다.',
    // 한글 이름, 소문자 영어 이름, 도감 번호 중 하나만 쳐도 정답으로 인정
    aliases: [name, nameEn.toLowerCase()],
  );
});