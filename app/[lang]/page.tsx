 // Example of updated PageProps type
    import type { Metadata } from 'next';

    type PageProps = {
      params: Promise<{ lang: string }>; // params is now a Promise
      // searchParams?: Promise<{ [key: string]: string | string[] | undefined }>; // if using searchParams
    };

    export default async function Page({ params }: PageProps) {
      const resolvedParams = await params; // Await the promise
      const { lang } = resolvedParams;
      // ... rest of your component logic
    }
}

export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
  ];
}
