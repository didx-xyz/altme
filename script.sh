
function pub {
  flutter clean
  for d in `ls packages`;
  do
    (
      cd "packages/$d"
      flutter clean
      flutter pub get
      flutter pub upgrade
    )
  done 
  flutter pub get
  flutter pub upgrade
}

function buildRunner {
  echo "build_runner"
  for d in `ls packages`;
  do
    (
      echo "$d"
      cd "packages/$d"
      flutter packages pub run build_runner build --delete-conflicting-outputs
    )
  done 
  flutter packages pub run build_runner build --delete-conflicting-outputs
}

function podUpdate {
  echo "pod install"
  cd ios
  rm Podfile.lock
  pod install
  pod update
  cd ..

}


if [[ "$*" == *-runDev* ]]; 
then
  echo "flutter run development"
  flutter run --flavor development --target lib/main_development.dart

elif [[ "$*" == *-runstage* ]]; 
then
  echo "flutter run staging"
  flutter run --flavor staging --target lib/main_staging.dart

elif [[ "$*" == *-run* ]]; 
then
  echo "flutter run production"
  flutter run --flavor production --target lib/main_production.dart

elif [[ "$*" == *-pod* ]]; 
then 
  podUpdate
elif [[ "$*" == *-android* ]]; 
then 
  pub
  buildRunner
  echo "deploy android"
  echo "Make sure you are in right branch"
  flutter build appbundle --flavor "production" --target "lib/main_production.dart"
  # cd android 
  # fastlane deploy
  echo "app bundle deployed on internal testing track"

elif [[ "$*" == *-ios* ]]; 
then 
  pub
  buildRunner
  podUpdate
  echo "deploy ios"
  echo "Make sure you are in right branch"
  flutter build ios --release --flavor "production" --target "lib/main_production.dart"
  cd ios 
  fastlane beta
elif [[ "$*" == *-pub* ]];
then
pub
else
  pub
  buildRunner
fi