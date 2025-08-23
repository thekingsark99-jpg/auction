import { getSettings } from '../../utils/api';

export default async function Page({ params }: { params: { lang: string } }) {
  const settings = await getSettings();
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      <pre>{JSON.stringify(settings, null, 2)}</pre>
    </main>
  );
}

export function generateStaticParams() {
  return [
   en: {
    name: 'English',
    icon: 'flags/english1',
  },
  es: {
    name: 'Español',
    icon: 'flags/spain',
  },
  fr: {
    name: 'Français',
    icon: 'flags/france',
  },
  de: {
    name: 'Deutsch',
    icon: 'flags/germany',
  },
  it: {
    name: 'Italiano',
    icon: 'flags/italy',
  },
  ja: {
    name: '日本語',
    icon: 'flags/japan',
  },
  ro: {
    name: 'Română',
    icon: 'flags/romania',
  },
  ar: {
    name: 'العربية',
    icon: 'flags/arabic',
  },
  hi: {
    name: 'हिंदी',
    icon: 'flags/india',
  },
  pt: {
    name: 'Português',
    icon: 'flags/portugal',
  },
  ru: {
    name: 'Русский',
    icon: 'flags/russia',
  },
  tr: {
    name: 'Türkçe',
    icon: 'flags/turkey',
  },
  zh: {
    name: '中文',
    icon: 'flags/china',
  },
  hu: {
    name: 'Magyar',
    icon: 'flags/hungary',
  },
  pl: {
    name: 'Polski',
    icon: 'flags/poland',
  },
  uk: {
    name: 'Українська',
    icon: 'flags/ukraine',
  },
}

