# Flower Clicker

꽃 테마 캐주얼 클리커/방치형 게임. 흙을 탭해 꽃가루를 모으고, 원하는 자리에 꽃을
심어 정원을 가꾸고, 자동 생산기(벌·나비)로 방치 수익을 얻는다. Godot 4.6.2(GDScript),
모바일 세로 타겟. 비주얼은 코드로 그린 탑다운 픽셀 스타일(Tiny Terraces 분위기 참고,
에셋은 오리지널).

## 실행 / 테스트 / 배포

```bash
# 실행 (Windows 에디터)
Godot_v4.6.2-stable_win64.exe --path .

# 단위 테스트 (Linux 헤드리스, GUT) — 30개
GODOT_SILENCE_ROOT_WARNING=1 godot --headless -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json

# CI: push마다 GitHub Actions 자동 실행
#  - Tests       : GUT 30개 테스트
#  - Deploy Web  : 웹 빌드 → GitHub Pages 배포 (Pages Source를 "GitHub Actions"로 설정 필요)
```

웹 빌드: https://jinha1226.github.io/proj_f2/

## 게임 루프

```
흙을 탭 → 꽃가루(Pollen) 획득
   ↓
상점에서 구매:
   ① 꽃 심기   → 심기 모드 진입 → 흙 타일을 탭해 그 자리에 심기(탭당 꽃가루 차감)
   ② 자동 생산기 → 벌/나비 구매 → 초당 꽃가루 자동 생산
   ↓
심은 꽃 수만큼 탭당 획득량↑ / 생산기만큼 초당 생산량↑
   ↓
앱 종료 중에도 적립(최대 2시간) → 재접속 시 "그동안 N 모았어요!"
```

## 조작

- **탭(짧게)**: 꽃가루 수집 (심기 모드에선 타일에 꽃 심기)
- **드래그**: 정원 이동(팬)
- **핀치 / 마우스 휠**: 줌 인/아웃
- **상점에서 꽃 선택** → 심기 모드 → 타일 격자에 맞춰 심기 → "완료"로 종료

## 구조

### 백엔드 (autoload, 단위 테스트 대상)
- `scripts/GameData.gd` — 밸런스 데이터 테이블 (꽃3/생산기2, 1.15배 가격곡선)
- `scripts/GameManager.gd` — 게임 상태의 단일 소유자: `tap`, `buy_upgrade`,
  `plant_flower(id,pos)`, `buy_producer`, `per_sec`, 자동생산, 시그널
- `scripts/SaveManager.gd` — JSON 저장/로드 + 오프라인 적립(2시간 캡).
  심은 꽃 위치(`placed`)까지 영속화
- `scripts/PlantMode.gd` — 심기 모드 상태(선택된 꽃)
- `scripts/Palette.gd` — 색 팔레트 (class_name)
- `scripts/Grid.gd` — 정원 타일 좌표 헬퍼 (class_name)

### 씬 / UI
- `scenes/Main.tscn` — World(카메라가 비추는 정원) + UI(CanvasLayer 고정)
- `scripts/ui/CameraController.gd` — 팬/줌/탭(수집·심기) 입력
- `scripts/ui/DirtBed.gd` — 탑다운 흙밭 + 나무틀 + 돌바닥 + 디테일
- `scripts/ui/GardenField.gd` — 타일에 스냅해 꽃 스폰(한 타일 한 송이), 저장 복원
- `scripts/ui/FlowerSprite.gd` — 코드로 그린 픽셀 꽃 덤불(레벨로 성장)
- `scripts/ui/GridOverlay.gd` — 심기 모드 타일 격자선
- `scripts/ui/ProducerLayer.gd` / `Bee.gd` — 들판을 배회하는 벌·나비
- `scripts/ui/ShopRow.gd` — 데이터 기반 상점 한 줄(심기/늘리기, 해금 게이팅)
- `scripts/ui/OfflinePopup.gd` — 오프라인 적립 팝업(닫기 버튼)
- `test/` — GUT 단위 테스트 30개

## 핵심 원칙

1. 모든 게임 상태는 `GameManager` 경유로만 변경
2. 밸런스 수치는 `GameData` 데이터 테이블에 분리 (코드에 하드코딩 금지)
3. UI는 시그널 구독 + GameManager 메서드 호출만 (상태 직접 변경 금지)
4. 순수 로직은 TDD(GUT) — 30개 테스트가 CI에서 자동 검증

## 개발 경과 (요약)

1. **MVP 백엔드** (TDD): GameData → GameManager(tap/buy/auto) → SaveManager(저장/오프라인)
2. **기본 UI**: 메인 씬, 상점, 플로팅 텍스트, 오프라인 팝업
3. **정원 리디자인**: 옆모습 도형 → 탑다운, 꽃 종류별 분리, 자유 비행 벌
4. **비주얼**: Tiny Terraces 참고(오리지널) — 흙밭/픽셀 꽃/팔레트, 단순화·밀도 조정
5. **큰 월드 + 카메라**: 줌/팬으로 넓은 정원 탐색
6. **심기 모드 + 타일 격자**: 원하는 타일에 꽃을 심어 정원 꾸미기(위치 저장)
7. **CI/CD**: GitHub Actions로 테스트 + 웹 배포

## 범위 밖 (향후)

- 정식 픽셀 스프라이트(라이선스 에셋팩 또는 AI 생성)로 비주얼 업그레이드
- 머지 / 수익화(광고·IAP) / 프레스티지
- 가로 모드(UI 반응형 재배치 필요)
