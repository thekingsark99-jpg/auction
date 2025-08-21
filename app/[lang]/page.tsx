import { getSettings } from '../../utils/api';

type PageProps = {
      params: Promise<{ lang: string }>; // params is now a Promise
      // searchParams?: Promise<{ [key: string]: string | string[] | undefined }>; // if using searchParams
    };

    export default async function Page({ params }: PageProps) {
      const resolvedParams = await params; // Await the promise
      const { lang } = resolvedParams;
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
  ];
}
