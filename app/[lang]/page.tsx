import { getSettings } from '@/path/to/your/api-utils';

interface PageProps {
  params: {
    lang: string;
  };
}

export default async function Page({ params }: PageProps) {
  // This is ONLY valid if you want to fetch data on the server
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
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
    // Add more supported languages here
  ];
}
